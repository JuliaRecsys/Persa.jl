using Documenter, Persa

makedocs(
    # options
    modules = [Persa],
    doctest = false,
    clean   = false
)

deploydocs(
    repo = "github.com/filipebraida/Persa.jl.git"
)
