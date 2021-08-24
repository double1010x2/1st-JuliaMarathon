using MosaicViews
using Test
using ImageCore, ColorVectorSpace
using OffsetArrays

@testset "MosaicView" begin
    @test_throws ArgumentError MosaicView(rand(2,2,2,2,2))

    @testset "1D input" begin
        A = [1,2,3]
        mv = @inferred MosaicView(A)
        @test parent(mv) === A
        @test typeof(mv) <: MosaicView
        @test eltype(mv) == eltype(A)
        @test size(mv) == (3, 1) # 1D vector is lifted to 2D matrix
        @test axes(mv) == (Base.OneTo(3), Base.OneTo(1))
        @test @inferred(getindex(mv, 1, 1)) === 1
        @test @inferred(getindex(mv, 2, 1)) === 2
    end

    @testset "2D input" begin
        A = [1 2;3 4]
        mv = @inferred MosaicView(A)
        @test parent(mv) === A
        @test typeof(mv) <: MosaicView
        @test eltype(mv) == eltype(A)
        @test size(mv) == (2, 2)
        @test axes(mv) == (Base.OneTo(2), Base.OneTo(2))
        @test @inferred(getindex(mv, 1, 1)) === 1
        @test @inferred(getindex(mv, 2, 1)) === 3
    end

    @testset "3D input" begin
        A = zeros(Int,2,2,2)
        A[:,:,1] = [1 2; 3 4]
        A[:,:,2] = [5 6; 7 8]
        mv = @inferred MosaicView(A)
        @test parent(mv) === A
        @test typeof(mv) <: MosaicView
        @test eltype(mv) == eltype(A)
        @test size(mv) == (4, 2)
        @test @inferred(getindex(mv,1,1)) === 1
        @test @inferred(getindex(mv,2,1)) === 3
        @test_throws BoundsError mv[0,1]
        @test_throws BoundsError mv[1,0]
        @test_throws BoundsError mv[1,3]
        @test_throws BoundsError mv[5,1]
        @test all(mv .== vcat(A[:,:,1],A[:,:,2]))
        # singleton dimension doesn't change anything
        @test mv == MosaicView(reshape(A,2,2,2,1))
    end

    @testset "4D input" begin
        A = zeros(Int,2,2,1,2)
        A[:,:,1,1] = [1 2; 3 4]
        A[:,:,1,2] = [5 6; 7 8]
        mv = @inferred MosaicView(A)
        @test parent(mv) === A
        @test typeof(mv) <: MosaicView
        @test eltype(mv) == eltype(A)
        @test size(mv) == (2, 4)
        @test @inferred(getindex(mv,1,1)) === 1
        @test @inferred(getindex(mv,2,1)) === 3
        @test_throws BoundsError mv[0,1]
        @test_throws BoundsError mv[1,0]
        @test_throws BoundsError mv[3,1]
        @test_throws BoundsError mv[1,5]
        @test all(mv .== hcat(A[:,:,1,1],A[:,:,1,2]))
        A = zeros(Int,2,2,2,3)
        A[:,:,1,1] = [1 2; 3 4]
        A[:,:,1,2] = [5 6; 7 8]
        A[:,:,1,3] = [9 10; 11 12]
        A[:,:,2,1] = [13 14; 15 16]
        A[:,:,2,2] = [17 18; 19 20]
        A[:,:,2,3] = [21 22; 23 24]
        mv = @inferred MosaicView(A)
        @test parent(mv) === A
        @test typeof(mv) <: MosaicView
        @test eltype(mv) == eltype(A)
        @test size(mv) == (4, 6)
        @test @inferred(getindex(mv,1,1)) === 1
        @test @inferred(getindex(mv,2,1)) === 3
        @test all(mv .== vcat(hcat(A[:,:,1,1],A[:,:,1,2],A[:,:,1,3]), hcat(A[:,:,2,1],A[:,:,2,2],A[:,:,2,3])))
    end
end

@testset "mosaicview" begin
    @testset "1D input" begin
        A1 = [1, 2, 3]
        A2 = [4, 5, 6]
        mv = mosaicview(A1, A2)
        @test typeof(mv) <: MosaicView
        @test eltype(mv) == eltype(A1)
        @test size(mv) == (6, 1)
        @test @inferred(getindex(mv, 1, 1)) == 1

        @test mosaicview(A1, A2; nrow=1) == [1 4; 2 5; 3 6]
        @test mosaicview(A1, A2; nrow=2) == reshape([1, 2, 3, 4, 5, 6], (6, 1))
        @test mosaicview(A1, A2) == mosaicview([A1, A2]) == mosaicview((A1, A2))
    end

    @testset "2D input" begin
        A = [i*ones(Int, 2, 3) for i in 1:4]
        Ao = [i*ones(Int, 0i:1, 0:2) for i in 1:4]

        for B in (A, tuple(A...), Ao)
            @test_throws ArgumentError mosaicview(B, nrow=0)
            @test_throws ArgumentError mosaicview(B, ncol=0)
            @test_throws ArgumentError mosaicview(B, nrow=1, ncol=1)

            mv = mosaicview(B)
            @test mosaicview(B...) == mv
            @test typeof(mv) <: MosaicView
            @test eltype(mv) == eltype(eltype(B))
            @test size(mv) == (8, 3)
            @test @inferred(getindex(mv,3,1)) === 2
            @test collect(mv) == [
                1  1  1
                1  1  1
                2  2  2
                2  2  2
                3  3  3
                3  3  3
                4  4  4
                4  4  4
            ]

            mv = mosaicview(B, nrow=2)
            @test typeof(mv) <: MosaicView
            @test eltype(mv) == eltype(eltype(B))
            @test size(mv) == (4, 6)
            @test collect(mv) == [
             1  1  1  3  3  3
             1  1  1  3  3  3
             2  2  2  4  4  4
             2  2  2  4  4  4
            ]
        end

        @test mosaicview(A...) == mosaicview(A)
        @test mosaicview(A..., nrow=2) == mosaicview(A, nrow=2)
        @test mosaicview(A..., nrow=2, rowmajor=true) == mosaicview(A, nrow=2, rowmajor=true)

        A1 = reshape([1 2 3], (1, 3))
        A2 = reshape([4;5;6], (3, 1))
        @test mosaicview([A1, A2]; center=false) == [
         1 2 3;
         0 0 0;
         0 0 0;
         4 0 0;
         5 0 0;
         6 0 0
        ]
        @test mosaicview([A1, A2]; center=true) == [
         0 0 0;
         1 2 3;
         0 0 0;
         0 4 0;
         0 5 0;
         0 6 0
        ]
        @test mosaicview([A1, A2]) == mosaicview([A1, A2]; center=true)

        # same size but different axes
        A1 = fill(1, 1:2, 1:2)
        A2 = fill(2, 2:3, 2:3)
        @test collect(mosaicview(A1, A2; center=true)) == [
            1 1 0;
            1 1 0;
            0 0 0;
            2 2 0;
            2 2 0;
            0 0 0;
        ]
        @test collect(mosaicview(A1, A2; center=false)) == [
            1 1 0;
            1 1 0;
            0 0 0;
            0 0 0;
            0 2 2;
            0 2 2;
        ]

        @test mosaicview(A1) == A1 # a trivial case
    end

    @testset "3D input" begin
        A = [(k+1)*l-1 for i in 1:2, j in 1:3, k in 1:2, l in 1:2]
        B = reshape(A, 2, 3, :)
        @test_throws ArgumentError mosaicview(B, nrow=0)
        @test_throws ArgumentError mosaicview(B, ncol=0)
        @test_throws ArgumentError mosaicview(B, nrow=1, ncol=1)
        @test mosaicview(B, center=2) == mosaicview(B) # no op

        mv = mosaicview(B)
        @test typeof(mv) <: MosaicView
        @test eltype(mv) == eltype(B)
        @test size(mv) == (8, 3)
        @test @inferred(getindex(mv,3,1)) === 2
        @test mv == [
            1  1  1
            1  1  1
            2  2  2
            2  2  2
            3  3  3
            3  3  3
            5  5  5
            5  5  5
        ]
        mv = mosaicview(B, nrow=2)
        @test mv == MosaicView(A)
        @test typeof(mv) != typeof(MosaicView(A))
        @test parent(parent(mv)).data == B
        @test typeof(mv) <: MosaicView
        @test eltype(mv) == eltype(B)
        @test size(mv) == (4, 6)

        @test mosaicview(B, B) == mosaicview(cat(B, B; dims=4))
        @test mosaicview(B, B, nrow=2) == mosaicview(cat(B, B; dims=4), nrow=2)
        @test mosaicview(B, B, nrow=2, rowmajor=true) == mosaicview(cat(B, B; dims=4), nrow=2, rowmajor=true)
    end

    @testset "4D input" begin
        A = [(k+1)*l-1 for i in 1:2, j in 1:3, k in 1:2, l in 1:2]
        @test_throws ArgumentError mosaicview(A, nrow=0)
        @test_throws ArgumentError mosaicview(A, ncol=0)
        @test_throws ArgumentError mosaicview(A, nrow=1, ncol=1)
        @test mosaicview(A, center=2) == mosaicview(A) # no op

        mv = mosaicview(A)
        @test mv == MosaicView(A)
        @test typeof(mv) != typeof(MosaicView(A))
        @test parent(parent(mv)).data == reshape(A, 2, 3, :)
        @test typeof(mv) <: MosaicView
        @test eltype(mv) == eltype(A)
        @test size(mv) == (4, 6)
        mv = mosaicview(A, npad=1)
        @test typeof(mv) <: MosaicView
        @test eltype(mv) == eltype(A)
        @test size(mv) == (5, 7)
        @test mv == mosaicview(A, nrow=2, npad=1)
        @test mv == mosaicview(A, ncol=2, npad=1)
        @test @inferred(getindex(mv,3,1)) === 0
        @test @inferred(getindex(mv,2,5)) === 3
        @test mv == [
            1  1  1  0  3  3  3
            1  1  1  0  3  3  3
            0  0  0  0  0  0  0
            2  2  2  0  5  5  5
            2  2  2  0  5  5  5
        ]
        mv = mosaicview(A, ncol=3, npad=1)
        @test typeof(mv) <: MosaicView
        @test eltype(mv) == eltype(A)
        @test size(mv) == (5, 11)
        @test mv == [
            1  1  1  0  3  3  3  0  0  0  0
            1  1  1  0  3  3  3  0  0  0  0
            0  0  0  0  0  0  0  0  0  0  0
            2  2  2  0  5  5  5  0  0  0  0
            2  2  2  0  5  5  5  0  0  0  0
        ]
        mv = mosaicview(A, rowmajor=true, ncol=3, npad=1)
        @test typeof(mv) <: MosaicView
        @test eltype(mv) == eltype(A)
        @test size(mv) == (5, 11)
        @test @inferred(getindex(mv,3,1)) === 0
        @test @inferred(getindex(mv,2,5)) === 2
        @test mv == [
            1  1  1  0  2  2  2  0  3  3  3
            1  1  1  0  2  2  2  0  3  3  3
            0  0  0  0  0  0  0  0  0  0  0
            5  5  5  0  0  0  0  0  0  0  0
            5  5  5  0  0  0  0  0  0  0  0
        ]
        mv = mosaicview(A, rowmajor=true, ncol=3, npad=2)
        @test typeof(mv) <: MosaicView
        @test eltype(mv) == eltype(A)
        @test size(mv) == (6, 13)
        @test mv == [
            1  1  1  0  0  2  2  2  0  0  3  3  3
            1  1  1  0  0  2  2  2  0  0  3  3  3
            0  0  0  0  0  0  0  0  0  0  0  0  0
            0  0  0  0  0  0  0  0  0  0  0  0  0
            5  5  5  0  0  0  0  0  0  0  0  0  0
            5  5  5  0  0  0  0  0  0  0  0  0  0
        ]
        mv = mosaicview(A, fillvalue=-1.0, rowmajor=true, ncol=3, npad=1)
        @test typeof(mv) <: MosaicView
        @test eltype(mv) == eltype(A)
        @test size(mv) == (5, 11)
        @test mv == [
             1   1   1  -1   2   2   2  -1   3   3   3
             1   1   1  -1   2   2   2  -1   3   3   3
            -1  -1  -1  -1  -1  -1  -1  -1  -1  -1  -1
             5   5   5  -1  -1  -1  -1  -1  -1  -1  -1
             5   5   5  -1  -1  -1  -1  -1  -1  -1  -1
        ]

        @test mosaicview(A, A) == mosaicview(cat(A, A; dims=5))
        @test mosaicview(A, A, nrow=2) == mosaicview(cat(A, A; dims=4), nrow=2)
        @test mosaicview(A, A, nrow=2, rowmajor=true) == mosaicview(cat(A, A; dims=4), nrow=2, rowmajor=true)
    end

    @testset "Colorant Array" begin
        A = rand(RGB{Float32}, 2, 3, 2, 2)
        mv = mosaicview(A)
        @test eltype(mv) == eltype(A)
        @test mv == @inferred(MosaicView(A))
        mv = mosaicview(A, rowmajor=true, ncol=3)
        @test eltype(mv) == eltype(A)
        @test @inferred(getindex(mv, 3, 4)) == RGB(0,0,0)
        mv = mosaicview(A, fillvalue=colorant"white", rowmajor=true, ncol=3)
        @test eltype(mv) == eltype(A)
        @test @inferred(getindex(mv, 3, 4)) == RGB(1,1,1)

        # this should work regardless they're of different size and color
        @test_nowarn mosaicview(rand(RGB{Float32}, 4, 4),
                                rand(Gray{N0f8}, 5, 5))
    end

    # all arrays should have the same dimension
    @test_throws ArgumentError mosaicview(ones(2), ones(1, 2))
    @test_throws ArgumentError mosaicview((ones(2), ones(1, 2)))
    @test_throws ArgumentError mosaicview([ones(2), ones(1, 2)])
end


@testset "deprecations" begin
    @info "deprecations are expected"
    A = [(k+1)*l-1 for i in 1:2, j in 1:3, k in 1:2, l in 1:2]
    mv_old = mosaicview(A, -1.0, rowmajor=true, ncol=3, npad=1)
    mv_new = mosaicview(A, fillvalue=-1.0, rowmajor=true, ncol=3, npad=1)
    @test mv_old == mv_new
end
