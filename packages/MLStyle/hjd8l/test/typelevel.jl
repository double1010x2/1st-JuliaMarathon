@testcase "type destructing" begin
    @lift @data internal S{A, B} begin
        S_1{A, B} :: (a :: A, b :: B) => S{A, B}
    end

    s = S_1(1, "2")
    @test @match s begin
        ::S{A, B} where {A, B} => A == Int && B == String
    end

    @testset "curried destructing" begin
        s = S_1(S_1(1, 2), "2")
        @match s begin
            ::S{String} => false
            ::S{A} where A => A <: S{Int, Int}
            _ => false
        end
    end

    @test @match S_1(nothing, nothing) begin
        ::S{Int, Int} => false
        ::S{T} where T => T >: Nothing
        _ => false
    end
end
