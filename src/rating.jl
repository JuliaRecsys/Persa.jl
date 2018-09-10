abstract type AbstractRating{T <: Number}
end

struct Rating{T <: Number} <: AbstractRating{T}
    value::T
    preference::Preference{T}
end

struct MissingRating{T <: Number} <: AbstractRating{T}
end

Rating(value::T, rating::Rating{T}) where T <: Number = Rating{T}(value, rating.preference)

value(rating::Rating) = rating.value
value(rating::MissingRating) = missing

Base.isnan(rating::Rating{T}) where T <: Number = false
Base.isnan(rating::MissingRating{T}) where T <: Number = true

Base.zero(::Type{AbstractRating{T}}) where T <: Number = MissingRating{T}()

function convert(values::Array{T})::Array{AbstractRating{T}} where T <: Number
    preferences = Preference(values)

    [Rating(value, preferences) for value in values]
end
