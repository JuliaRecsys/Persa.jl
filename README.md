# Persa.jl

*Collaborative Filtering in Julia*

| **Documentation**                                                               | **Build Status**                                                                                |
|:-------------------------------------------------------------------------------:|:-----------------------------------------------------------------------------------------------:|
| [![][docs-dev-img]][docs-dev-url] | [![][ci-img]][ci-url] [ [![][codecov-img]][codecov-url] |


## Installation

The package can be installed with the Julia package manager.
From the Julia REPL, type `]` to enter the Pkg REPL mode and run:

```
pkg> add Persa
```

Or, equivalently, via the `Pkg` API:

```julia
julia> import Pkg; Pkg.add("Persa")
```

## Packages

Some important packages:
- **[DatasetsCF](https://github.com/JuliaRecsys/DatasetsCF.jl)**: Package with collaborative filtering datasets.
- **[EvaluationCF](https://github.com/JuliaRecsys/EvaluationCF.jl)**: Packages for evaluation of predictive algorithms. It contains metrics, data partitioning and more. (under construction)
- **[ModelBasedCF](https://github.com/JuliaRecsys/ModelBasedCF.jl)**: Model based algorithms. (under construction)

[contrib-url]: https://juliadocs.github.io/Documenter.jl/latest/man/contributing/

[docs-dev-img]: https://img.shields.io/badge/docs-dev-blue.svg
[docs-dev-url]: https://juliarecsys.github.io/Persa.jl/dev

[docs-stable-img]: https://img.shields.io/badge/docs-latest-blue?style=flat-square
[docs-stable-url]: https://juliarecsys.github.io/Persa.jl/stable

[ci-img]: https://img.shields.io/github/checks-status/JuliaRecsys/Persa.jl/master?style=flat-square
[ci-url]: https://github.com/JuliaRecsys/Persa.jl/actions

[appveyor-img]: https://ci.appveyor.com/api/projects/status/xx7nimfpnl1r4gx0?svg=true
[appveyor-url]: https://ci.appveyor.com/project/JuliaDocs/documenter-jl

[codecov-img]: hhttps://img.shields.io/codecov/c/github/JuliaRecsys/Persa.jl?style=flat-square
[codecov-url]: https://codecov.io/gh/JuliaRecsys/Persa.jl

[coverage-img]: https://coveralls.io/repos/JuliaRecsys/Persa.jl/badge.svg?branch=master&service=github
[coverage-url]: https://coveralls.io/github/JuliaRecsys/Persa.jl?branch=master

[issues-url]: https://github.com/JuliaRecsys/Persa.jl/issues
