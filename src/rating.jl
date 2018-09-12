abstract type AbstractRating{T <: Number}
end

struct PredictRating{T <: Number} <: AbstractRating{T}
    value::Real
    target::T
    PredictRating(x::Real, preference::Preference{T}) where T <: Number = new{T}(correct(x, preference), round(x, preference))
end

struct Rating{T <: Number} <: AbstractRating{T}
    value::T
    Rating(x::T, preference::Preference{T}) where T <: Number = new{T}(correct(x, preference))
end

struct MissingRating{T <: Number} <: AbstractRating{T}
end

MissingRating() = MissingRating{Number}()

value(rating::Rating) = rating.value
value(rating::PredictRating) = rating.value
value(rating::MissingRating) = missing

Base.isnan(rating::AbstractRating{T}) where T <: Number = false
Base.isnan(rating::MissingRating{T}) where T <: Number = true

Base.zero(::Type{AbstractRating{T}}) where T <: Number = MissingRating{T}()

function convert(values::Array{T}, preference::Preference{T})::Array{AbstractRating{T}} where T <: Number
    [Rating(value, preference) for value in values]
end

function convert(values::Array{T})::Array{AbstractRating{T}} where T <: Number
    convert(values, Preference(values))
end

Base.:+(r1::AbstractRating{T}, r2::AbstractRating{T}) where {T <: Number} = value(r1) + value(r2)
Base.:+(r1::AbstractRating{T}, r2::MissingRating{T}) where {T <: Number} = value(r1)
Base.:+(r1::MissingRating{T}, r2::AbstractRating{T}) where {T <: Number} = value(r2)
Base.:+(r1::MissingRating{T}, r2::MissingRating{T}) where {T <: Number} = MissingRating{T}()

Base.:-(r1::AbstractRating{T}, r2::AbstractRating{T}) where {T <: Number} =value(r1) - value(r2)
Base.:-(r1::AbstractRating{T}, r2::MissingRating{T}) where {T <: Number} = value(r1)
Base.:-(r1::MissingRating{T}, r2::AbstractRating{T}) where {T <: Number} = value(r2)
Base.:-(r1::MissingRating{T}, r2::MissingRating{T}) where {T <: Number} = MissingRating{T}()

Base.:+(r1::AbstractRating{T}, x::Number) where {T <: Number} = value(r1) + x
Base.:-(r1::AbstractRating{T}, x::Number) where {T <: Number} = value(r1) - x
Base.:*(r1::AbstractRating{T}, x::Number) where {T <: Number} = value(r1) * x
Base.:/(r1::AbstractRating{T}, x::Number) where {T <: Number} = value(r1) / x
