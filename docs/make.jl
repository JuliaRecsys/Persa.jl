using Documenter, Persa

makedocs(
    modules = [Persa],
    analytics = "UA-128580038-1"
)

# Only build plots in travis if we are deploying
# And dont install the dependencies unless we are deploying
function myDeps()
    if get(ENV, "TRAVIS", "") != ""
        println("Installing deploy dependencies")
        run(`pip install --user pygments mkdocs`)
        makePlots()
    end
end

deploydocs(
    repo = "github.com/JuliaRecsys/Persa.jl.git",
    latest = "master",
    julia = "1.0",
    deps = myDeps
)
