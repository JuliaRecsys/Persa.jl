abstract type Model{T} <: AbstractDataset{T}
end

users(model::Model) = model.users
items(model::Model) = model.items

checkuser(model::Model, user::Int) = (user >= 0 && user <= users(model)) ? user : error("invalid user id ($user)")
checkitem(model::Model, item::Int) = (item >= 0 && item <= items(model)) ? item : error("invalid item id ($item)")

predict(model::Model, user::Int, item::Int) where T = missing

train!(model::Model, dataset::Dataset) = nothing

function Base.getindex(model::Model{T}, user::Int, item::Int) where T
    checkuser(model, user)
    checkitem(model, item)

    value = predict(model, user, item)

    if !ismissing(value)
        return PredictRating(correct(value, model.preference), model.preference)
    end

    return MissingRating{T}()
end

function Base.getindex(model::Model{T}, dataset::Dataset{T}) where T
    predicts = Vector{UserPreference{T}}(undef, length(dataset))

    for i = 1:length(dataset)
        (u, v, r) = dataset[i]
        predicts[i] = UserPreference{T}(u, v, model[u, v])
    end

    return predicts
end
