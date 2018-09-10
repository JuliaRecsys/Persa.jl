abstract type AbstractRating{T <: Number}
end

struct Rating{T <: Number} <: AbstractRating{T}
    value::T
    preference::Preference{T}
    Rating(value::T, preference::Preference{T}) where T <: Number = new{T}(correct(value, preference), preference)
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

Base.:+(r1::Rating{T}, r2::Rating{T}) where {T <: Number} = Rating(value(r1) + value(r2), r1.preference)
Base.:+(r1::MissingRating{T}, r2::Rating{T}) where {T <: Number} = Rating(value(r2), r2.preference)
Base.:+(r1::Rating{T}, r2::MissingRating{T}) where {T <: Number} = Rating(value(r1), r1.preference)
Base.:+(r1::MissingRating{T}, r2::MissingRating{T}) where {T <: Number} = MissingRating{T}()

Base.:-(r1::Rating{T}, r2::Rating{T}) where {T <: Number} = Rating(value(r1) - value(r2), r1.preference)
Base.:-(r1::MissingRating{T}, r2::Rating{T}) where {T <: Number} = Rating(value(r2), r2.preference)
Base.:-(r1::Rating{T}, r2::MissingRating{T}) where {T <: Number} = Rating(value(r1), r1.preference)
Base.:-(r1::MissingRating{T}, r2::MissingRating{T}) where {T <: Number} = MissingRating{T}()

Base.:+(r1::Rating{T}, x::Number) where {T <: Number} = value(r1) + x
Base.:-(r1::Rating{T}, x::Number) where {T <: Number} = value(r1) - x
Base.:*(r1::Rating{T}, x::Number) where {T <: Number} = value(r1) * x
Base.:/(r1::Rating{T}, x::Number) where {T <: Number} = value(r1) / x
