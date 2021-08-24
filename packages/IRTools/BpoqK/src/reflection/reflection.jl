using Core: CodeInfo, Typeof
using Core.Compiler: InferenceState, MethodInstance, widenconst, svec
using InteractiveUtils: typesof

worldcounter() = ccall(:jl_get_world_counter, UInt, ())

isprecompiling() = ccall(:jl_generating_output, Cint, ()) == 1

struct TypedMeta
  frame::InferenceState
  method::Method
  code::CodeInfo
  ret
end

function Base.show(io::IO, meta::TypedMeta)
  print(io, "Typed metadata for ")
  print(io, meta.method)
end

define_typeinf_code2() = isprecompiling() ||
@eval Core.Compiler function typeinf_code2(method::Method, @nospecialize(atypes), sparams::SimpleVector, run_optimizer::Bool, params::Params)
    if $(VERSION >= v"1.2-")
      code = specialize_method(method, atypes, sparams)
    else
      code = code_for_method(method, atypes, sparams, params.world)
    end
    code === nothing && return (nothing, Any)
    ccall(:jl_typeinf_begin, Cvoid, ())
    result = InferenceResult(code)
    frame = InferenceState(result, false, params)
    frame === nothing && return (nothing, Any)
    if typeinf(frame) && run_optimizer
        opt = OptimizationState(frame)
        optimize(opt, result.result)
        opt.src.inferred = true
    end
    ccall(:jl_typeinf_end, Cvoid, ())
    frame.inferred || return (nothing, Any)
    return frame
end

"""
    typed_meta(Tuple{...})

Same as [`@meta`](@ref), but represents the method after type inference. IR
constructed with typed metadata will have type annotations.

See also [`@typed_meta`](@ref).

    julia> IRTools.typed_meta(Tuple{typeof(gcd),Int,Int})
    Typed metadata for gcd(a::T, b::T) where T<:Union{Int128, Int16, Int32, Int64, Int8, UInt128, UInt16, UInt32, UInt64, UInt8} in Base at intfuncs.jl:31
"""
function typed_meta(T; world = worldcounter(), optimize = false)
  F = T.parameters[1]
  F isa DataType && (F.name.module === Core.Compiler ||
                     F <: Core.Builtin ||
                     F <: Core.Builtin) && return nothing
  _methods = Base._methods_by_ftype(T, -1, world)
  length(_methods) == 1 || return nothing
  type_signature, sps, method = first(_methods)
  params = Core.Compiler.Params(world)
  frame = Core.Compiler.typeinf_code2(method, type_signature, sps, optimize, params)
  ci = frame.src
  ci.inferred = true
  if ci.ssavaluetypes == 0 # constant return; IRCode doesn't like this
    ci.ssavaluetypes = Any[Any]
  end
  return TypedMeta(frame, method, ci, widenconst(frame.result.result))
end

struct Meta
  method::Method
  instance::MethodInstance
  code::CodeInfo
  nargs::Int
  sparams
end

function Base.show(io::IO, meta::Meta)
  print(io, "Metadata for ")
  print(io, meta.method)
end

# Workaround for what appears to be a Base bug
untvar(t::TypeVar) = t.ub
untvar(x) = x

"""
    meta(Tuple{...})

Construct metadata for a given method signature. Metadata can then be used to
construct [`IR`](@ref) or used to perform other reflection on the method.

See also [`@meta`](@ref), [`typed_meta`](@ref).

    julia> IRTools.meta(Tuple{typeof(gcd),Int,Int})
    Metadata for gcd(a::T, b::T) where T<:Union{Int128, Int16, Int32, Int64, Int8, UInt128, UInt16, UInt32, UInt64, UInt8} in Base at intfuncs.jl:31
"""
function meta(T; types = T, world = worldcounter())
  F = T.parameters[1]
  F == typeof(invoke) && return invoke_meta(T; world = world)
  F isa DataType && (F.name.module === Core.Compiler ||
                     F <: Core.Builtin ||
                     F <: Core.Builtin) && return nothing
  _methods = Base._methods_by_ftype(T, -1, world)
  length(_methods) == 0 && return nothing
  type_signature, sps, method = last(_methods)
  sps = svec(map(untvar, sps)...)
  @static if VERSION >= v"1.2-"
    mi = Core.Compiler.specialize_method(method, types, sps)
    ci = Base.isgenerated(mi) ? Core.Compiler.get_staged(mi) : Base.uncompressed_ast(method)
  else
    mi = Core.Compiler.code_for_method(method, types, sps, world, false)
    ci = Base.isgenerated(mi) ? Core.Compiler.get_staged(mi) : Base.uncompressed_ast(mi)
  end
  Base.Meta.partially_inline!(ci.code, [], method.sig, Any[sps...], 0, 0, :propagate)
  Meta(method, mi, ci, method.nargs, sps)
end

function invoke_tweaks!(ci::CodeInfo)
  ci.slotnames = [:invoke, ci.slotnames[1], :T, ci.slotnames[2:end]...]
  ci.slotflags = [0x00, ci.slotflags[1], 0x00, ci.slotflags[2:end]...]
  ci.code = map(ci.code) do x
    prewalk(x) do x
      x isa SlotNumber ? SlotNumber(x.id == 1 ? 2 : x.id+2) : x
    end
  end
end

function invoke_meta(T; world)
  F = T.parameters[2]
  A = T.parameters[3]::Type{<:Type{<:Tuple}}
  S = T.parameters[4:end]
  T = Tuple{F,A.parameters[1].parameters...}
  S = Tuple{F,S...}
  m = meta(T, types = S, world = world)
  invoke_tweaks!(m.code)
  return Meta(m.method, m.instance, m.code, m.nargs+2, m.sparams)
end

"""
    @meta f(args...)

Convenience macro for retrieving metadata without writing a full type signature.

    julia> IRTools.@meta gcd(10, 5)
    Metadata for gcd(a::T, b::T) where T<:Union{Int128, Int16, Int32, Int64, Int8, UInt128, UInt16, UInt32, UInt64, UInt8} in Base at intfuncs.jl:31
"""
macro meta(ex)
  isexpr(ex, :call) || error("@meta f(args...)")
  f, args = ex.args[1], ex.args[2:end]
  :(meta(typesof($(esc.((f, args...))...))))
end

"""
    @typed_meta f(args...)

Convenience macro for retrieving typed metadata without writing a full type signature.

    julia> IRTools.@typed_meta gcd(10, 5)
    Typed metadata for gcd(a::T, b::T) where T<:Union{Int128, Int16, Int32, Int64, Int8, UInt128, UInt16, UInt32, UInt64, UInt8} in Base at intfuncs.jl:31
"""
macro typed_meta(ex)
  isexpr(ex, :call) || error("@meta f(args...)")
  f, args = ex.args[1], ex.args[2:end]
  :(typed_meta(typesof($(esc.((f, args...))...))))
end

function code_ir(f, T)
  m = meta(Tuple{Typeof(f),T.parameters...})
  return IR(m)
end

function code_irm(ex)
  isexpr(ex, :call) || error("@code_ir f(args...)")
  f, args = ex.args[1], ex.args[2:end]
  :($code_ir($(esc(f)), typesof($(esc.(args)...))))
end

"""
    @code_ir f(args...)

Convenience macro similar to `@code_lowered` or `@code_typed`. Retrieves the IR
for the given function call.

    julia> @code_ir gcd(10, 5)
    1: (%1, %2, %3)
      %4 = %2 == 0
      br 4 unless %4
    2: ...
"""
macro code_ir(ex)
  code_irm(ex)
end

codeinfo(m::Meta) = m.code
codeinfo(m::TypedMeta) = m.code

function argnames!(meta, names...)
  meta.code.slotnames = [names...]
end
