using Test, YaoBase

@testset "test error & exceptions" begin
    include("error.jl")
    include("exceptions.jl")
end

@testset "test abstract interface" begin
    include("abstract_register.jl")
end

@testset "test utils" begin
    include("math.jl")
end
