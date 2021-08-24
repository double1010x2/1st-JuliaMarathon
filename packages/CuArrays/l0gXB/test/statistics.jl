@testset "Statistics" begin

using Statistics

@testset "std" begin
    @test testf(std, rand(10))
    @test testf(std, rand(10,1,2))
    @test testf(std, rand(10,1,2), corrected=true)
    @test testf(std, rand(10,1,2), dims=1)
end
@testset "var" begin
    @test testf(var, rand(10))
    @test testf(var, rand(10,1,2))
    @test testf(var, rand(10,1,2), corrected=true)
    @test testf(var, rand(10,1,2), dims=1)
end

end
