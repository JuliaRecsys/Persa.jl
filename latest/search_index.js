var documenterSearchIndex = {"docs": [

{
    "location": "index.html#",
    "page": "Introduction",
    "title": "Introduction",
    "category": "page",
    "text": ""
},

{
    "location": "index.html#Persa.jl-1",
    "page": "Introduction",
    "title": "Persa.jl",
    "category": "section",
    "text": "Persa é um pacote para"
},

{
    "location": "index.html#Package-Features-1",
    "page": "Introduction",
    "title": "Package Features",
    "category": "section",
    "text": "Supports Julia 0.7 and 1.0."
},

{
    "location": "index.html#Goal-1",
    "page": "Introduction",
    "title": "Goal",
    "category": "section",
    "text": "The main aim is to create a framework that facilitates the study of collaborative filtering in Julia. Collaborative filtering frameworks basically are library with set of prediction and recommendation algorithms. Most don\'t provide tools that facilitate the construction of new algorithms. In some cases they provide, they don\'t use some scientific computation language and this making development more difficult.In this scenario Persa will provide a set of tools that will facilitate the development of collaborative filtering algorithms. It will extend the Julia language by building a specific domain language (DSL) and thus increasing the productivity of development. The developer will not worry about data access and the construction of the main tasks."
},

{
    "location": "index.html#Collaborative-Filtering-1",
    "page": "Introduction",
    "title": "Collaborative Filtering",
    "category": "section",
    "text": "Collaborative filtering is one of the most successful approaches to Recommendation Systems. The purpose of this approach is to use user ratings to suggest some item that the user has not consumed and should like. This approach can be represented by a matrix where the content of it is the evaluation performed by the user on an item. However, this matrix is not necessarily complete since the user didn\'t necessarily consume all items.|          |  Item #1 |  Item #2 |  Item #3 | |:––––:|:––––:|:––––:|:––––:| |  User #1 |    4     |          |    2     | |  User #2 |    4     |    5     |    3     | |  User #3 |    3     |    4     |          | |  User #4 |          |    5     |    4     |Persa can be divided into large two parts: data access and predictive model"
},

{
    "location": "index.html#Data-1",
    "page": "Introduction",
    "title": "Data",
    "category": "section",
    "text": "The Persa.Preference represents all possibilities of ratings within a system. It is used to validate a rating. We can define that in this system the ratings are defined as integers of [1,5]:julia> preference = Persa.Preference([1, 2, 3, 4, 5])\nRatings Preference: [1, 2, 3, 4, 5]So, we can represent a rating as:julia> Persa.Rating(1, preference)\nRating: 1The action of a user evaluating an item is represented by the Persa.UserPreference structure. Using the matrix as an example we have:julia> x = Persa.UserPreference(1, 1, Persa.Rating(1, preference))\n(user: 1, item: 1, rating: 1)In this way, we can create the above matrix.julia> data\n9-element Array{Persa.UserPreference{Int64},1}:\n (user: 1, item: 1, rating: 4)\n (user: 1, item: 3, rating: 2)\n (user: 2, item: 1, rating: 4)\n (user: 2, item: 2, rating: 5)\n (user: 2, item: 3, rating: 3)\n (user: 3, item: 1, rating: 3)\n (user: 3, item: 2, rating: 4)\n (user: 4, item: 2, rating: 5)\n (user: 3, item: 3, rating: 4)The Persa.Dataset structure is the representation of the user-item matrix.julia> dataset = Persa.Dataset(data, 4, 3, preference)\nCollaborative Filtering Dataset\n- # users: 4\n- # items: 3\n- # ratings: 9\n- Ratings Preference: [1, 2, 3, 4, 5]It is possible to access the data through linear indexing or by the user and item indices.In the case of linear the related Persa.UserPreference will be returned.julia> dataset[1]\n(user: 1, item: 1, rating: 4)Already using the index through the user and item will be returning the rating.julia> dataset[1,1]\nRating: 4"
},

{
    "location": "index.html#Model-1",
    "page": "Introduction",
    "title": "Model",
    "category": "section",
    "text": "Persa has a second important abstraction. It interprets the predictive model as an access to the user-item matrix. The access to the data and the predictions become the same. In this way, the access to the information is standardized.The model will be a structure that will be of the Persa.Model type. This structure will need to have the information of the set of preferences and the amount of users and items.mutable struct RandomModel <: Persa.Model\n    preference::Persa.Preference\n    users::Int\n    items::Int\nend\n\nRandomModel(dataset::Persa.Dataset) = RandomModel(dataset.preference, Persa.users(dataset), Persa.items(dataset))Finally, it will be necessary to construct a forecasting method using this model.Persa.predict(model::RandomModel, user::Int, item::Int) = rand(model.preference.possibles)The Persa has several abstractions that facilitate the use of the forecast. It will follow the same logic that was made for the dataset.julia> model = RandomModel(ds)\nRandomModel(Ratings Preference: [1, 2, 3, 4, 5], 4, 3)\n\njulia> model[1,1]\nRating: 2 (2)"
},

]}
