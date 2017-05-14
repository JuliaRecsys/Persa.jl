using Documenter, Persa

makedocs(
    # options
    modules = [Persa],
    doctest = false,
    clean   = false
)

deploydocs(
    deps   = Deps.pip("pygments", "mkdocs", "mkdocs-material", "python-markdown-math"),
    repo = "github.com/filipebraida/Persa.jl.git",
    julia = "0.5",
    osname = "linux"
)
