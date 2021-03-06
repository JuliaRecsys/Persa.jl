using Persa
using Test
using DataFrames

function createdummydatasetone()
    df = DataFrame()
    df[!, :user] = [1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 7, 7, 7]
    df[!, :item] = [1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6, 1, 2, 4, 5, 6, 2, 4, 5]
    df[!, :rating] = [2.5, 3.5, 3.0, 3.5, 2.5, 3.0, 3, 3.5, 1.5, 5, 3, 3.5, 2.5, 3.0, 3.5, 4.0, 3.5, 3.0, 4.0, 2.5, 4.5, 3.0, 4.0, 2.0, 3.0, 2.0, 3.0, 3.0, 4.0, 5.0, 3.5, 3.0, 4.5, 4.0, 1.0]
    return df
end

function createdummydatasettwo()
    df = DataFrame()
    df[!, :user] = [1, 1, 1, 1, 1, 1, 2, 2, 2, 2, 2, 2, 3, 3, 3, 3, 4, 4, 4, 4, 4, 5, 5, 5, 5, 5, 5, 6, 6, 6, 6, 6, 7, 7, 7]
    df[!, :item] = [1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6, 1, 2, 3, 4, 2, 3, 4, 5, 6, 1, 2, 3, 4, 5, 6, 1, 2, 4, 5, 6, 2, 4, 5]
    df[!, :rating] = [2, 7, 3, 3, 8, 3, 3, 3, 1, 9, 3, 3, 2, 3, 10, 4, 3, 3, 4, 2, 4, 3, 4, 2, 3, 2, 3, 3, 4, 5, 9, 10, 7, 6, 8]
    return df
end
####
include("ratingTest.jl")
include("datasetTest.jl")
include("learnTest.jl")
