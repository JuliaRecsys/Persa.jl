using Documenter, Persa

makedocs(
    modules = [Persa],
    format = :html,
    sitename = "Persa.jl",
    authors = "Filipe Braida and contributors.",
    analytics = "UA-128580038-1",
    pages    = Any[
        "Introduction"   => "index.md"
    ]
)

deploydocs(
    repo = "github.com/JuliaRecsys/Persa.jl.git",
    target = "build",
    deps = nothing,
    make = nothing,
    julia  = "1.0",
)
