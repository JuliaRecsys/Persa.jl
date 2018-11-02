using Documenter, Persa

makedocs(
    modules = [Persa],
    format = :html,
    sitename = "Persa",
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
