module Junk

export imnotdefined

function useme(args)
    @info "then you're sane"
end

macro immacro(expr)
    quote
        @warn "You shouldn't use me in most your use cases"
    end
end

const toplevelval = "you should jump to me !"

# mock overloaded method
struct JunkType end
Base.isconst(::JunkType) = false

include("SubJunks.jl")

function samefoo(args) end
macro samefoo(ex) end

end
