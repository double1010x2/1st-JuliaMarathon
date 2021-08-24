module CUDAapi

using Libdl
using Logging

# FIXME: replace with an additional log level when we depend on 0.7+
macro trace(ex...)
    esc(:(@debug $(ex...)))
end

include("util.jl")

include("discovery.jl")
include("availability.jl")

include("complex.jl")
include("library_types.jl")

include("call.jl")

end
