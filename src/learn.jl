abstract type Model
end

users(model::Model) = model.users
items(model::Model) = model.items

checkuser(model::Model, user::Int) = (user >= 0 && user <= users(model)) ? user : error("invalid user id ($user)")
checkitem(model::Model, item::Int) = (item >= 0 && item <= items(model)) ? item : error("invalid item id ($item)")

predict(model::Model, user::Int, item::Int) = 0
train!(model::Model, dataset::Dataset) = nothing

function Base.getindex(model::Model, user::Int, item::Int)
    checkuser(model, user)
    checkitem(model, item)

    correct(predict(model, user, item), model.preference)
end

Base.getindex(model::Model, user::Int, c::Colon) = [model[user, item] for item = 1:items(model)]
Base.getindex(model::Model, c::Colon, item::Int) = [model[user, item] for user = 1:users(model)]

function Base.getindex(model::Model, dataset::Dataset)
    predicts = Vector{Float64}(undef, length(dataset))

    for i = 1:length(dataset)
        (u, v, r) = dataset[i]
        predicts[i] = model[u, v]
    end

    return predicts
end
