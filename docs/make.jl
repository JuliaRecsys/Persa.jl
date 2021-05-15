using Documenter, Persa

makedocs(
    modules = [Persa],
    sitename = "Persa.jl",
    authors = "Filipe Braida and contributors.",
    format = Documenter.HTML(
        # Use clean URLs, unless built as a "local" build
        canonical = "https://juliadocs.github.io/Documenter.jl/stable/",
        assets = ["assets/favicon.ico"],
        analytics = "UA-128580038-1",
        highlights = ["yaml"],
    ),
    pages = [
        "Home" => "index.md",
        "Getting Started" => "man/getting_started.md"
    ]
)

deploydocs(
    repo = "github.com/JuliaRecsys/Persa.jl.git",
    target = "build",
    push_preview = true
)
