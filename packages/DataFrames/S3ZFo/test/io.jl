module TestIO

using Test, DataFrames, CategoricalArrays, Dates

# Test LaTeX export
@testset "LaTeX export" begin
    df = DataFrame(A = 1:4,
                B = ["\$10.0", "M&F", "A~B", "\\alpha"],
                C = ["A", "B", "C", "S"],
                D = [1.0, 2.0, missing, 3.0],
                E = CategoricalArray(["a", missing, "c", "d"]),
                F = Vector{String}(undef, 4)
                )
    str = """
        \\begin{tabular}{r|cccccc}
        \t& A & B & C & D & E & F\\\\
        \t\\hline
        \t& $(Int) & String & String & Float64⍰ & Categorical…⍰ & String\\\\
        \t\\hline
        \t1 & 1 & \\\$10.0 & A & 1.0 & a & \\#undef \\\\
        \t2 & 2 & M\\&F & B & 2.0 &  & \\#undef \\\\
        \t3 & 3 & A\\textasciitilde{}B & C &  & c & \\#undef \\\\
        \t4 & 4 & \\textbackslash{}\\textbackslash{}alpha & S & 3.0 & d & \\#undef \\\\
        \\end{tabular}
        """
    @test repr(MIME("text/latex"), df) == str
    @test repr(MIME("text/latex"), eachcol(df)) == str
    @test repr(MIME("text/latex"), eachrow(df)) == str

    @test_throws ArgumentError DataFrames._show(stdout, MIME("text/latex"),
                                                DataFrame(ones(2,2)), rowid=10)
end

@testset "Huge LaTeX export" begin
    df = DataFrame(a=1:1000)
    ioc = IOContext(IOBuffer(), :displaysize => (10, 10), :limit => false)
    show(ioc, "text/latex", df)
    @test length(String(take!(ioc.io))) > 10000

    ioc = IOContext(IOBuffer(), :displaysize => (10, 10), :limit => true)
    show(ioc, "text/latex", df)
    @test length(String(take!(ioc.io))) < 10000
end

#Test HTML output for IJulia and similar
@testset "HTML output" begin
    df = DataFrame(Fish = ["Suzy", "Amir"], Mass = [1.5, missing])
    io = IOBuffer()
    show(io, "text/html", df)
    str = String(take!(io))
    @test str == "<table class=\"data-frame\"><thead><tr><th>" *
                 "</th><th>Fish</th><th>Mass</th></tr>" *
                 "<tr><th></th><th>String</th><th>Float64⍰</th></tr></thead><tbody>" *
                 "<p>2 rows × 2 columns</p>" *
                 "<tr><th>1</th><td>Suzy</td><td>1.5</td></tr>" *
                 "<tr><th>2</th><td>Amir</td><td>missing</td></tr></tbody></table>"

    df = DataFrame(Fish = Vector{String}(undef, 2), Mass = [1.5, missing])
    io = IOBuffer()
    show(io, "text/html", df)
    str = String(take!(io))
    @test str == "<table class=\"data-frame\"><thead><tr><th>" *
                 "</th><th>Fish</th><th>Mass</th></tr>" *
                 "<tr><th></th><th>String</th><th>Float64⍰</th></tr></thead><tbody>" *
                 "<p>2 rows × 2 columns</p>" *
                 "<tr><th>1</th><td>#undef</td><td>1.5</td></tr>" *
                 "<tr><th>2</th><td>#undef</td><td>missing</td></tr></tbody></table>"

    io = IOBuffer()
    show(io, "text/html", eachrow(df))
    str = String(take!(io))
    @test str == "<p>2×2 DataFrameRows</p>" *
                 "<table class=\"data-frame\"><thead><tr><th>" *
                 "</th><th>Fish</th><th>Mass</th></tr>" *
                 "<tr><th></th><th>String</th><th>Float64⍰</th></tr></thead><tbody>" *
                 "<tr><th>1</th><td>#undef</td><td>1.5</td></tr>" *
                 "<tr><th>2</th><td>#undef</td><td>missing</td></tr></tbody></table>"

    io = IOBuffer()
    show(io, "text/html", eachcol(df))
    str = String(take!(io))
    @test str == "<p>2×2 DataFrameColumns (with names=false)</p>" *
                 "<table class=\"data-frame\"><thead><tr><th>" *
                 "</th><th>Fish</th><th>Mass</th></tr>" *
                 "<tr><th></th><th>String</th><th>Float64⍰</th></tr></thead><tbody>" *
                 "<tr><th>1</th><td>#undef</td><td>1.5</td></tr>" *
                 "<tr><th>2</th><td>#undef</td><td>missing</td></tr></tbody></table>"

    io = IOBuffer()
    show(io, "text/html", eachcol(df, true))
    str = String(take!(io))
    @test str == "<p>2×2 DataFrameColumns (with names=true)</p>" *
                 "<table class=\"data-frame\"><thead><tr><th>" *
                 "</th><th>Fish</th><th>Mass</th></tr>" *
                 "<tr><th></th><th>String</th><th>Float64⍰</th></tr></thead><tbody>" *
                 "<tr><th>1</th><td>#undef</td><td>1.5</td></tr>" *
                 "<tr><th>2</th><td>#undef</td><td>missing</td></tr></tbody></table>"

    io = IOBuffer()
    show(io, "text/html", df[1, :])
    str = String(take!(io))
    @test str == "<p>DataFrameRow (2 columns)</p><table class=\"data-frame\">" *
                 "<thead><tr><th></th><th>Fish</th><th>Mass</th></tr><tr><th></th>" *
                 "<th>String</th><th>Float64⍰</th></tr></thead><tbody><tr><th>1</th>" *
                 "<td>#undef</td><td>1.5</td></tr></tbody></table>"

    io = IOBuffer()
    show(io, MIME"text/html"(), df, summary=false)
    str = String(take!(io))
    @test str == "<table class=\"data-frame\"><thead><tr><th>" *
                 "</th><th>Fish</th><th>Mass</th></tr>" *
                 "<tr><th></th><th>String</th><th>Float64⍰</th></tr></thead><tbody>" *
                 "<tr><th>1</th><td>#undef</td><td>1.5</td></tr>" *
                 "<tr><th>2</th><td>#undef</td><td>missing</td></tr></tbody></table>"

    io = IOBuffer()
    show(io, MIME"text/html"(), eachrow(df), summary=false)
    str = String(take!(io))
    @test str == "<table class=\"data-frame\"><thead><tr><th>" *
                 "</th><th>Fish</th><th>Mass</th></tr>" *
                 "<tr><th></th><th>String</th><th>Float64⍰</th></tr></thead><tbody>" *
                 "<tr><th>1</th><td>#undef</td><td>1.5</td></tr>" *
                 "<tr><th>2</th><td>#undef</td><td>missing</td></tr></tbody></table>"

    io = IOBuffer()
    show(io, MIME"text/html"(), eachcol(df), summary=false)
    str = String(take!(io))
    @test str == "<table class=\"data-frame\"><thead><tr><th>" *
                 "</th><th>Fish</th><th>Mass</th></tr>" *
                 "<tr><th></th><th>String</th><th>Float64⍰</th></tr></thead><tbody>" *
                 "<tr><th>1</th><td>#undef</td><td>1.5</td></tr>" *
                 "<tr><th>2</th><td>#undef</td><td>missing</td></tr></tbody></table>"

    io = IOBuffer()
    show(io, MIME"text/html"(), df[1, :], summary=false)
    str = String(take!(io))
    @test str == "<table class=\"data-frame\"><thead><tr><th></th><th>Fish</th>" *
                 "<th>Mass</th></tr><tr><th></th><th>String</th><th>Float64⍰</th></tr></thead>" *
                 "<tbody><tr><th>1</th><td>#undef</td><td>1.5</td></tr></tbody></table>"

    @test_throws ArgumentError DataFrames._show(stdout, MIME("text/html"),
                                                DataFrame(ones(2,2)), rowid=10)
end

# test limit attribute of IOContext is used
@testset "limit attribute" begin
    df = DataFrame(a=1:1000)
    ioc = IOContext(IOBuffer(), :displaysize => (10, 10), :limit => false)
    show(ioc, "text/html", df)
    @test length(String(take!(ioc.io))) > 10000

    ioc = IOContext(IOBuffer(), :displaysize => (10, 10), :limit => true)
    show(ioc, "text/html", df)
    @test length(String(take!(ioc.io))) < 10000
end

@testset "printtable" begin
    df = DataFrame(A = 1:3,
                B = 'a':'c',
                C = ["A", "B", "C"],
                D = CategoricalArray(string.('a':'c')),
                E = CategoricalArray(["A", "B", missing]),
                F = Vector{Union{Int, Missing}}(1:3),
                G = missings(3),
                H = fill(missing, 3))

    @test sprint(DataFrames.printtable, df) ==
        """
        "A","B","C","D","E","F","G","H"
        1,"'a'","A","a","A","1",missing,missing
        2,"'b'","B","b","B","2",missing,missing
        3,"'c'","C","c",missing,"3",missing,missing
        """
end

@testset "csv/tsv output" begin
    df = DataFrame(a = [1,2], b = [1.0, 2.0])

    for x in [df, eachcol(df), eachrow(df)]
        @test sprint(show, "text/csv", x) == """
        "a","b"
        1,1.0
        2,2.0
        """
        @test sprint(show, "text/tab-separated-values", x) == """
        "a"\t"b"
        1\t1.0
        2\t2.0
        """
    end
end

@testset "empty data frame and DataFrameRow" begin
    df = DataFrame(a = [1,2], b = [1.0, 2.0])

    @test sprint(show, "text/csv", df[:, 2:1]) == ""
    @test sprint(show, "text/tab-separated-values", df[:, 2:1]) == ""
    @test sprint(show, "text/html", df[:, 2:1]) ==
          "<table class=\"data-frame\"><thead><tr><th></th></tr><tr><th></th></tr>" *
          "</thead><tbody><p>0 rows × 0 columns</p></tbody></table>"
    @test sprint(show, "text/latex", df[:, 2:1]) ==
          "\\begin{tabular}{r|}\n\t& \\\\\n\t\\hline\n\t& \\\\\n\t\\hline\n\\end{tabular}\n"

    @test sprint(show, "text/csv", @view df[:, 2:1]) == ""
    @test sprint(show, "text/tab-separated-values", @view df[:, 2:1]) == ""
    @test sprint(show, "text/html", @view df[:, 2:1]) ==
          "<table class=\"data-frame\"><thead><tr><th></th></tr><tr><th></th></tr>" *
          "</thead><tbody><p>0 rows × 0 columns</p></tbody></table>"
    @test sprint(show, "text/latex", @view df[:, 2:1]) ==
          "\\begin{tabular}{r|}\n\t& \\\\\n\t\\hline\n\t& \\\\\n\t\\hline\n\\end{tabular}\n"

    @test sprint(show, "text/csv", df[1, 2:1]) == ""
    @test sprint(show, "text/tab-separated-values", df[1, 2:1]) == ""
    @test sprint(show, "text/html", df[1, 2:1]) ==
          "<p>DataFrameRow (0 columns)</p><table class=\"data-frame\">" *
          "<thead><tr><th></th></tr><tr><th></th></tr></thead><tbody></tbody></table>"
    @test sprint(show, "text/latex", df[1, 2:1]) ==
          "\\begin{tabular}{r|}\n\t& \\\\\n\t\\hline\n\t& \\\\\n\t\\hline\n\\end{tabular}\n"
end

@testset "consistency" begin
    df = DataFrame(a = [1, 1, 2, 2], b = [5, 6, 7, 8], c = 1:4)
    push!(df.c, 5)
    @test_throws AssertionError sprint(show, "text/html", df)
    @test_throws AssertionError sprint(show, "text/latex", df)
    @test_throws AssertionError sprint(show, "text/csv", df)
    @test_throws AssertionError sprint(show, "text/tab-separated-values", df)

    df = DataFrame(a = [1, 1, 2, 2], b = [5, 6, 7, 8], c = 1:4)
    push!(DataFrames._columns(df), df[:, :a])
    @test_throws AssertionError sprint(show, "text/html", df)
    @test_throws AssertionError sprint(show, "text/latex", df)
    @test_throws AssertionError sprint(show, "text/csv", df)
    @test_throws AssertionError sprint(show, "text/tab-separated-values", df)
end

end # module
