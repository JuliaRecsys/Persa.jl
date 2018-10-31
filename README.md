# Persa.jl - Collaborative Filtering in Julia

[![Build Status](https://travis-ci.org/JuliaRecsys/Persa.jl.svg?branch=master)](https://travis-ci.org/JuliaRecsys/Persa.jl)
[![Coverage Status](https://coveralls.io/repos/JuliaRecsys/Persa.jl/badge.svg?branch=master&service=github)](https://coveralls.io/github/JuliaRecsys/Persa.jl?branch=master)
[![codecov.io](http://codecov.io/github/JuliaRecsys/Persa.jl/coverage.svg?branch=master)](http://codecov.io/github/JuliaRecsys/Persa.jl?branch=master)

**Installation**: at the Julia REPL, `Pkg.add("Persa")`

**Reporting Issues and Contributing**: See [CONTRIBUTING.md](CONTRIBUTING.md)

## Goal

The main aim is to create a framework that facilitates the study of collaborative filtering in Julia.
Collaborative filtering frameworks basically are library with set of prediction and recommendation algorithms.
Most don't provide tools that facilitate the construction of new algorithms.
In some cases they provide, they don't use some scientific computation language and this making development more difficult

In this scenario Persa will provide a set of tools that will facilitate the development of collaborative filtering algorithms.
It will extend the Julia language by building a specific domain language (DSL) and thus increasing the productivity of development.
The developer will not worry about data acess and the construction of the main tasks.

## Collaborative Filtering

Collaborative filtering is one of the most successful approaches to Recommendation Systems.
The purpose of this approach is to use user ratings to suggest some item that the user has not consumed and should like.
This approach can be represented by a matrix where the content of it is the evaluation performed by the user on an item.
However, this matrix is not necessarily complete since the user din't necessarily consume all items.

|          |  Item #1 |  Item #2 |  Item #3 |
|:--------:|:--------:|:--------:|:--------:|
|  User #1 |    4     |          |    2     |
|  User #2 |    4     |    5     |    3     |
|  User #3 |    3     |    4     |          |
|  User #4 |          |    5     |    4     |

Persa can be divided into large two parts: data access and predictive model

### Data

The ```Persa.Preference``` represents all possibilities of ratings within a system. 
It is used to validate a rating. 
We can define that in this system the ratings are defined as integers of [1,5]:

```
julia> preference = Persa.Preference([1, 2, 3, 4, 5])
Ratings Preference: [1, 2, 3, 4, 5]
```

So, we can represent a rating as:

```
julia> Persa.Rating(1, preference)
Rating: 1
```

The action of a user evaluating an item is represented by the ```Persa.UserPreference``` structure.
Using the matrix as an example we have:

```
julia> x = Persa.UserPreference(1, 1, Persa.Rating(1, preference))
(user: 1, item: 1, rating: 1)
```

In this way, we can create the above matrix.

```
julia> data
9-element Array{Persa.UserPreference{Int64},1}:
 (user: 1, item: 1, rating: 4)
 (user: 1, item: 3, rating: 2)
 (user: 2, item: 1, rating: 4)
 (user: 2, item: 2, rating: 5)
 (user: 2, item: 3, rating: 3)
 (user: 3, item: 1, rating: 3)
 (user: 3, item: 2, rating: 4)
 (user: 4, item: 2, rating: 5)
 (user: 3, item: 3, rating: 4)
```

The ```Persa.Dataset``` structure is the representation of the user-item matrix. 

```
julia> dataset = Persa.Dataset(data, 4, 3, preference)
Collaborative Filtering Dataset
- # users: 4
- # items: 3
- # ratings: 9
- Ratings Preference: [1, 2, 3, 4, 5]
```

It is possible to access the data through linear indexing or by the user and item indices.

In the case of linear the related ```Persa.UserPreference``` will be returned.
```
julia> dataset[1]
(user: 1, item: 1, rating: 4)
```

Already using the indíces through the user and item will be returning the rating.
```
julia> dataset[1,1]
Rating: 4
```

### Model

## Collaborative Filtering
