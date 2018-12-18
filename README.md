# Persa.jl

*Collaborative Filtering in Julia*

| **Documentation**                                                               | **Build Status**                                                                                |
|:-------------------------------------------------------------------------------:|:-----------------------------------------------------------------------------------------------:|
| [![][docs-dev-img]][docs-dev-url] | [![][travis-img]][travis-url] [![][coverage-img]][coverage-url] [![][codecov-img]][codecov-url] |


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
[docs-dev-url]: https://juliarecsys.github.io/Persa.jl/latest

[docs-stable-img]: https://img.shields.io/badge/docs-stable-blue.svg
[docs-stable-url]: https://juliarecsys.github.io/Persa.jl/stable

[travis-img]: https://travis-ci.org/JuliaRecsys/Persa.jl.svg?branch=master
[travis-url]: https://travis-ci.org/JuliaRecsys/Persa.jl

[appveyor-img]: https://ci.appveyor.com/api/projects/status/xx7nimfpnl1r4gx0?svg=true
[appveyor-url]: https://ci.appveyor.com/project/JuliaDocs/documenter-jl

[codecov-img]: https://codecov.io/gh/JuliaRecsys/Persa.jl/branch/master/graph/badge.svg
[codecov-url]: https://codecov.io/gh/JuliaRecsys/Persa.jl

[coverage-img]: https://coveralls.io/repos/JuliaRecsys/Persa.jl/badge.svg?branch=master&service=github
[coverage-url]: https://coveralls.io/github/JuliaRecsys/Persa.jl?branch=master

[issues-url]: https://github.com/JuliaRecsys/Persa.jl/issues
