module Pers

# package code goes here

include("datasets.jl")

include("learn.jl")

include("kfolds.jl")
include("measures.jl")

include("utils.jl")
include("similarity.jl")

include("regularizedSVD.jl")
include("improvedRegularizedSVD.jl")
include("globalMean.jl")
include("userKNN.jl")

include("surpriseMethods.jl")

include("holdout.jl")

include("experiments.jl")

include("modelTune.jl")

end # module
