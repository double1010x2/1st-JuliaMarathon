using Documenter, JuliaFormatter

makedocs(
    sitename = "JuliaFormatter",
    format = Documenter.HTML(prettyurls = true),
    modules = [JuliaFormatter],
    pages = [
        "Introduction" => "index.md",
        "How It Works" => "how_it_works.md",
        "Code Style" => "style.md",
        "Skipping Formatting" => "skipping_formatting.md",
        "Syntax Transforms" => "transforms.md",
        "Custom Styles" => "custom_styles.md",
        "API Reference" => "api.md",
    ],
)

deploydocs(repo = "github.com/domluna/JuliaFormatter.jl.git")
