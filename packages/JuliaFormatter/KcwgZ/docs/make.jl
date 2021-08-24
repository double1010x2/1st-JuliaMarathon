using Documenter, JuliaFormatter

makedocs(
    sitename = "JuliaFormatter",
    format = Documenter.HTML(prettyurls = get(ENV, "CI", nothing) == "true"),
    modules = [JuliaFormatter],
    pages = [
        "Introduction" => "index.md",
        "How It Works" => "how_it_works.md",
        "Code Style" => "style.md",
        "Skipping Formatting" => "skipping_formatting.md",
        "Syntax Transforms" => "transforms.md",
        "Custom Styles" => "custom_styles.md",
        "YAS Style" => "yas_style.md",
        "Configuration File" => "config.md",
        "API Reference" => "api.md",
    ],
)

deploydocs(repo = "github.com/domluna/JuliaFormatter.jl.git", push_preview = true)
