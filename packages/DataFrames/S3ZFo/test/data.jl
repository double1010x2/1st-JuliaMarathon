module TestData

using Test, DataFrames, Random, Statistics
const ≅ = isequal

@testset "constructors" begin
    df1 = DataFrame([[1, 2, missing, 4], ["one", "two", missing, "four"]], [:Ints, :Strs])
    df2 = DataFrame([[1, 2, missing, 4], ["one", "two", missing, "four"]])
    df3 = DataFrame([[1, 2, missing, 4]])
    df6 = DataFrame([[1, 2, missing, 4], [1, 2, missing, 4], ["one", "two", missing, "four"]],
                    [:A, :B, :C])
    df7 = DataFrame(x = [1, 2, missing, 4], y = ["one", "two", missing, "four"])
    @test size(df7) == (4, 2)
    @test df7[!, :x] ≅ [1, 2, missing, 4]

    #test_group("description functions")
    @test size(df6, 1) == 4
    @test size(df6, 2) == 3
    @test names(df6) == [:A, :B, :C]
    @test names(df2) == [:x1, :x2]
    @test names(df7) == [:x, :y]

    #test_group("ref")
    @test df6[2, 3] == "two"
    @test ismissing(df6[3, 3])
    @test df6[2, :C] == "two"
    @test df6[!, :B] ≅ [1, 2, missing, 4]
    @test size(df6[:, [2,3]], 2) == 2
    @test size(df6[2,:], 1) == ncol(df6) # this is a DataFrameRow
    @test size(df6[2:2,:], 1) == 1
    @test size(df6[[1, 3], [1, 3]]) == (2, 2)
    @test size(df6[1:2, 1:2]) == (2, 2)
    @test size(first(df6,2)) == (2, 3)
    # lots more to do

    #test_group("assign")
    df6[!, 3] = ["un", "deux", "trois", "quatre"]
    @test df6[1, 3] == "un"
    df6[!, :B] = [4, 3, 2, 1]
    @test df6[1,2] == 4
    df6[!, :D] = [true, false, true, false]
    @test df6[1,4]
    select!(df6, Not(:D))
    @test names(df6) == [:A, :B, :C]
    @test size(df6, 2) == 3

    #test_context("SubDataFrames")

    #test_group("constructors")
    # single index is rows
    sdf6a = view(df6, 1:1, :)
    sdf6b = view(df6, 2:3, :)
    sdf6c = view(df6, [true, false, true, false], :)
    @test size(sdf6a) == (1,3)
    sdf6d = view(df6, [1,3], [:B])
    @test size(sdf6d) == (2,1)
    sdf6e = view(df6, [0x01], :)
    @test size(sdf6e) == (1,3)
    sdf6f = view(df6, UInt64[1, 2], :)
    @test size(sdf6f) == (2,3)
    sdf6g = view(df6, [1,3], :B)
    sdf6h = view(df6, 1, :B)
    sdf6i = view(df6, 1, [:B])

    #test_group("ref")
    @test sdf6a[1,2] == 4

    #test_context("Within")
    #test_group("Associative")

    #test_group("DataFrame")
    Random.seed!(1)
    N = 20
    d1 = Vector{Union{Int64, Missing}}(rand(1:2, N))
    d2 = CategoricalArray(["A", "B", missing])[rand(1:3, N)]
    d3 = randn(N)
    d4 = randn(N)
    df7 = DataFrame([d1, d2, d3], [:d1, :d2, :d3])

    #test_group("groupby")
    gd = groupby(df7, :d1)
    @test length(gd) == 2
    @test gd[1][:, :d2] ≅ d2[d1 .== 1]
    @test gd[2][:, :d2] ≅ d2[d1 .== 2]
    @test gd[1][:, :d3] == d3[d1 .== 1]
    @test gd[2][:, :d3] == d3[d1 .== 2]

    g1 = groupby(df7, [:d1, :d2])
    g2 = groupby(df7, [:d2, :d1])
    @test g1[1][:, :d3] == g2[1][:, :d3]

    res = 0.0
    for x in g1
        res += sum(x[:, :d1])
    end
    @test res == sum(df7[!, :d1])

    @test aggregate(DataFrame(a=1), identity) == DataFrame(a_identity=1)

    df8 = aggregate(df7[:, [1, 3]], sum)
    @test df8[1, :d1_sum] == sum(df7[!, :d1])

    df8 = aggregate(df7, :d2, [sum, length], sort=true)
    @test df8[1:2, :d2] == ["A", "B"]
    @test size(df8, 1) == 3
    @test size(df8, 2) == 5
    @test sum(df8[!, :d1_length]) == N
    @test all(df8[!, :d1_length] .> 0)
    @test df8[!, :d1_length] == [sum(isequal.(d2, "A")), sum(isequal.(d2, "B")), sum(ismissing.(d2))]
    df8′ = aggregate(df7, 2, [sum, length], sort=true)
    @test df8 ≅ df8′
    adf = aggregate(groupby(df7, :d2, sort=true), [sum, length])
    @test df8 ≅ adf
    adf′ = aggregate(groupby(df7, 2, sort=true), [sum, length])
    @test df8 ≅ adf′
    adf = aggregate(groupby(df7, :d2), [sum, length], sort=true)
    @test sort(df8, [:d1_sum, :d3_sum, :d1_length, :d3_length]) ≅ adf
    adf′ = aggregate(groupby(df7, 2), [sum, length], sort=true)
    @test adf ≅ adf′

    df = DataFrame(a = [3, missing, 1], b = [100, 200, 300])
    for dosort in (true, false), doskipmissing in (true, false)
        @test aggregate(df, :a, sum, sort=dosort, skipmissing=doskipmissing) ≅
              aggregate(groupby(df, :a, sort=dosort, skipmissing=doskipmissing), sum)
    end

    # Check column names
    anonf = x -> sum(x)
    adf = aggregate(df7, :d2, [mean, anonf])
    @test names(adf) == [:d2, :d1_mean, :d3_mean,
                         :d1_function, :d3_function]
    adf = aggregate(df7, :d2, [mean, mean, anonf, anonf])
    @test names(adf) == [:d2, :d1_mean, :d3_mean, :d1_mean_1, :d3_mean_1,
                         :d1_function, :d3_function, :d1_function_1, :d3_function_1]

    df9 = aggregate(df7, :d2, [sum, length], sort=true)
    @test df9 ≅ df8
    df9′ = aggregate(df7, 2, [sum, length], sort=true)
    @test df9′ ≅ df8

    df10 = DataFrame([[1:4;], [2:5;],
                      ["a", "a", "a", "b" ], ["c", "d", "c", "d"]],
                     [:d1, :d2, :d3, :d4])

    gd = groupby(df10, [:d3], sort=true)
    ggd = groupby(gd[1], [:d3, :d4], sort=true) # make sure we can groupby SubDataFrames
    @test ggd[1][1, :d3] == "a"
    @test ggd[1][1, :d4] == "c"
    @test ggd[1][2, :d3] == "a"
    @test ggd[1][2, :d4] == "c"
    @test ggd[2][1, :d3] == "a"
    @test ggd[2][1, :d4] == "d"
end

@testset "completecases and dropmissing" begin
    df1 = DataFrame([Vector{Union{Int, Missing}}(1:4), Vector{Union{Int, Missing}}(1:4)])
    df2 = DataFrame([Union{Int, Missing}[1, 2, 3, 4], ["one", "two", missing, "four"]])

    @test df2[completecases(df2), :] == df2[[1, 2, 4], :]
    @test dropmissing(df2) == df2[[1, 2, 4], :]
    returned = dropmissing(df1)
    @test df1 == returned && df1 !== returned
    df2b = copy(df2)
    @test dropmissing!(df2b) === df2b
    @test df2b == df2[[1, 2, 4], :]
    df1b = copy(df1)
    @test dropmissing!(df1b) === df1b
    @test df1b == df1

    @test_throws ArgumentError completecases(DataFrame())
    @test_throws MethodError completecases(DataFrame(x=1), true)

    for cols in (:x2, [:x2], [:x1, :x2], 2, [2], 1:2, [true, true], [false, true], :,
                 r"x2", r"x", Not(1), Not([1]), Not(Int[]), Not([]), Not(Symbol[]),
                 Not(1:0), Not([true, false]), Not(:x1), Not([:x1]))
        @test df2[completecases(df2, cols), :] == df2[[1, 2, 4], :]
        @test dropmissing(df2, cols) == df2[[1, 2, 4], :]
        returned = dropmissing(df1, cols)
        @test df1 == returned && df1 !== returned
        df2b = copy(df2)
        @test dropmissing!(df2b, cols) === df2b
        @test df2b == df2[[1, 2, 4], :]
        @test dropmissing(df2, cols) == df2b
        @test df2 != df2b
        df1b = copy(df1)
        @test dropmissing!(df1b, cols) === df1b
        @test df1b == df1
    end

    df = DataFrame(a=[1, missing, 3])
    sdf = view(df, :, :)
    @test dropmissing(sdf) == DataFrame(a=[1, 3])
    @test eltype(dropmissing(df, disallowmissing=false).a) == Union{Int, Missing}
    @test eltype(dropmissing(df, disallowmissing=true).a) == Int
    @test eltype(dropmissing(sdf, disallowmissing=false).a) == Union{Int, Missing}
    @test eltype(dropmissing(sdf, disallowmissing=true).a) == Int
    @test df ≅ DataFrame(a=[1, missing, 3]) # make sure we did not mutate df

    @test_throws ArgumentError dropmissing!(sdf)

    df2 = copy(df)
    @test dropmissing!(df, disallowmissing=true) === df
    @test dropmissing!(df2, disallowmissing=false) === df2
    @test eltype(df.a) == Int
    @test eltype(df2.a) == Union{Int, Missing}
    @test df.a == df2.a == [1, 3]

    a = [1,2]
    df = DataFrame(a=a, copycols=false)
    @test dropmissing!(df) === df
    @test a === df.a
    dfx = dropmissing(df)
    @test df == df
    @test dfx !== df
    @test dfx.a !== df.a
    @test a === df.a # we did not touch df

    b = Union{Int, Missing}[1, 2]
    df = DataFrame(b=b)
    @test eltype(dropmissing(df).b) == Int
    @test eltype(dropmissing!(df).b) == Int
end

@testset "merge" begin
    Random.seed!(1)
    df1 = DataFrame(a = shuffle!(Vector{Union{Int, Missing}}(1:10)),
                    b = rand(Union{Symbol, Missing}[:A,:B], 10),
                    v1 = Vector{Union{Float64, Missing}}(randn(10)))

    df2 = DataFrame(a = shuffle!(Vector{Union{Int, Missing}}(1:5)),
                    b2 = rand(Union{Symbol, Missing}[:A,:B,:C], 5),
                    v2 = Vector{Union{Float64, Missing}}(randn(5)))

    m1 = join(df1, df2, on = :a, kind=:inner)
    @test m1[!, :a] == df1[!, :a][df1[!, :a] .<= 5] # preserves df1 order
    m2 = join(df1, df2, on = :a, kind = :outer)
    @test m2[!, :a] == df1[!, :a] # preserves df1 order
    @test m2[!, :b] == df1[!, :b] # preserves df1 order
    @test m2[indexin(df1[!, :a], m2[!, :a]), :b] == df1[!, :b]
    @test m2[indexin(df2[!, :a], m2[!, :a]), :b2] == df2[!, :b2]
    @test m2[indexin(df1[!, :a], m2[!, :a]), :v1] == df1[!, :v1]
    @test m2[indexin(df2[!, :a], m2[!, :a]), :v2] == df2[!, :v2]
    @test all(ismissing, m2[map(x -> !in(x, df2[!, :a]), m2[!, :a]), :b2])
    @test all(ismissing, m2[map(x -> !in(x, df2[!, :a]), m2[!, :a]), :v2])

    df1 = DataFrame(a = Union{Int, Missing}[1, 2, 3],
                    b = Union{String, Missing}["America", "Europe", "Africa"])
    df2 = DataFrame(a = Union{Int, Missing}[1, 2, 4],
                    c = Union{String, Missing}["New World", "Old World", "New World"])

    m1 = join(df1, df2, on = :a, kind = :inner)
    @test m1[!, :a] == [1, 2]

    m2 = join(df1, df2, on = :a, kind = :left)
    @test m2[!, :a] == [1, 2, 3]

    m3 = join(df1, df2, on = :a, kind = :right)
    @test m3[!, :a] == [1, 2, 4]

    m4 = join(df1, df2, on = :a, kind = :outer)
    @test m4[!, :a] == [1, 2, 3, 4]

    # test with missings (issue #185)
    df1 = DataFrame()
    df1[!, :A] = ["a", "b", "a", missing]
    df1[!, :B] = Union{Int, Missing}[1, 2, 1, 3]

    df2 = DataFrame()
    df2[!, :A] = ["a", missing, "c"]
    df2[!, :C] = Union{Int, Missing}[1, 2, 4]

    m1 = join(df1, df2, on = :A)
    @test size(m1) == (3,3)
    @test m1[!, :A] ≅ ["a","a", missing]

    m2 = join(df1, df2, on = :A, kind = :outer)
    @test size(m2) == (5,3)
    @test m2[!, :A] ≅ ["a", "b", "a", missing, "c"]
end

@testset "join tests" begin
    Random.seed!(1)
    df1 = DataFrame(a = rand(Union{Symbol, Missing}[:x,:y], 10),
                    b = rand(Union{Symbol, Missing}[:A,:B], 10),
                    v1 = Vector{Union{Float64, Missing}}(randn(10)))

    df2 = DataFrame(a = Union{Symbol, Missing}[:x,:y][[1,2,1,1,2]],
                    b = Union{Symbol, Missing}[:A,:B,:C][[1,1,1,2,3]],
                    v2 = Vector{Union{Float64, Missing}}(randn(5)))
    df2[1,:a] = missing

    m1 = join(df1, df2, on = [:a,:b])
    @test m1[!, :a] == Union{Missing, Symbol}[:x, :x, :y, :y, :y, :x, :x, :x]
    m2 = join(df1, df2, on = [:a,:b], kind = :outer)
    @test ismissing(m2[10,:v2])
    @test m2[!, :a] ≅ [:x, :x, :y, :y, :y, :x, :x, :y, :x, :y, missing, :y]

    Random.seed!(1)
    function spltdf(d)
        d[!, :x1] = map(x -> x[1], d[!, :a])
        d[!, :x2] = map(x -> x[2], d[!, :a])
        d[!, :x3] = map(x -> x[3], d[!, :a])
        d
    end
    df1 = DataFrame(a = ["abc", "abx", "axz", "def", "dfr"], v1 = randn(5))
    df2 = DataFrame(a = ["def", "abc","abx", "axz", "xyz"], v2 = randn(5))
    spltdf(df1)
    spltdf(df2)

    m1 = join(df1, df2, on = :a, makeunique=true)
    m2 = join(df1, df2, on = [:x1, :x2, :x3], makeunique=true)
    @test m1[!, :a] == m2[!, :a]
end

@testset "nonunique, nonunique, unique! with extra argument" begin
    df1 = DataFrame(a = Union{String, Missing}["a", "b", "a", "b", "a", "b"],
                    b = Vector{Union{Int, Missing}}(1:6),
                    c = Union{Int, Missing}[1:3;1:3])
    df = vcat(df1, df1)
    @test findall(nonunique(df)) == collect(7:12)
    @test findall(nonunique(df, :)) == collect(7:12)
    @test findall(nonunique(df, Colon())) == collect(7:12)
    @test findall(nonunique(df, :a)) == collect(3:12)
    @test findall(nonunique(df, [:a, :c])) == collect(7:12)
    @test findall(nonunique(df, r"[ac]")) == collect(7:12)
    @test findall(nonunique(df, Not(2))) == collect(7:12)
    @test findall(nonunique(df, Not([2]))) == collect(7:12)
    @test findall(nonunique(df, Not(:b))) == collect(7:12)
    @test findall(nonunique(df, Not([:b]))) == collect(7:12)
    @test findall(nonunique(df, Not([false, true, false]))) == collect(7:12)
    @test findall(nonunique(df, [1, 3])) == collect(7:12)
    @test findall(nonunique(df, 1)) == collect(3:12)

    @test unique(df) == df1
    @test unique(df, :) == df1
    @test unique(df, Colon()) == df1
    @test unique(df, 2:3) == df1
    @test unique(df, 3) == df1[1:3,:]
    @test unique(df, [1, 3]) == df1
    @test unique(df, [:a, :c]) == df1
    @test unique(df, r"[ac]") == df1
    @test unique(df, Not(2)) == df1
    @test unique(df, Not([2])) == df1
    @test unique(df, Not(:b)) == df1
    @test unique(df, Not([:b])) == df1
    @test unique(df, Not([false, true, false])) == df1
    @test unique(df, :a) == df1[1:2,:]
    @test_throws ArgumentError unique(DataFrame())
    @test_throws ArgumentError nonunique(DataFrame())

    unique!(df, [1, 3])
    @test df == df1
    for cols in (r"[ac]", Not(:b), Not(2), Not([:b]), Not([2]), Not([false, true, false]))
        df = vcat(df1, df1)
        unique!(df, cols)
        @test df == df1
    end
end

@testset "filter() and filter!()" begin
    df = DataFrame(x = [3, 1, 2, 1], y = ["b", "c", "a", "b"])
    @test filter(r -> r[:x] > 1, df) == DataFrame(x = [3, 2], y = ["b", "a"])
    @test filter!(r -> r[:x] > 1, df) === df == DataFrame(x = [3, 2], y = ["b", "a"])
    df = DataFrame(x = [3, 1, 2, 1, missing], y = ["b", "c", "a", "b", "c"])
    @test_throws TypeError filter(r -> r[:x] > 1, df)
    @test_throws TypeError filter!(r -> r[:x] > 1, df)
end

end # module
