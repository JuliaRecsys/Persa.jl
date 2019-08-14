abstract type AbstractRating{T <: Number}
end

struct PredictRating{T <: Number} <: AbstractRating{T}
    value::Real
    target::T
    PredictRating(x::Real, preference::Preference{T}) where T <: Number = new{T}(correct(x, preference), round(x, preference))
end

struct Rating{T <: Number} <: AbstractRating{T}
    value::T
    history::Vector{Persa.Rating{T}}
    Rating(x::T, preference::Preference{T}) where T <: Number = new{T}(correct(x, preference), Vector{Persa.Rating{T}}())
end

struct MissingRating{T <: Number} <: AbstractRating{T}
end

function Base.getindex(rating::Persa.Rating, i::Int)
    if i < 1 || (i - 1) > length(rating.history)
        throw(BoundsError(rating, i))
    elseif i == 1
        return rating
    end

    return rating.history[i-1]
end

MissingRating() = MissingRating{Number}()

function rerating(r1::Persa.Rating{T}, r2::Persa.Rating{T}) where T
    push!(r1.history, r2)
    return r1
end

value(rating::Rating) = rating.value
value(rating::PredictRating) = rating.value
value(rating::MissingRating) = missing

Base.string(x::Rating) = string(value(x))
Base.print(io::IO, x::Rating) = print(io, string(x))
Base.show(io::IO, x::Rating) = print(io, "Rating: ", x)

Base.string(x::PredictRating) = string(value(x), " (", x.target ,")")
Base.print(io::IO, x::PredictRating) = print(io, string(x))
Base.show(io::IO, x::PredictRating) = print(io, "Rating: ", x)

Base.string(x::MissingRating) = string(value(x))
Base.print(io::IO, x::MissingRating) = print(io, string(x))
Base.show(io::IO, x::MissingRating) = print(io, "Rating: ", x)

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
Base.:+(x::Number, r1::AbstractRating{T}) where {T <: Number} = value(r1) + x

Base.:-(r1::AbstractRating{T}, x::Number) where {T <: Number} = value(r1) - x
Base.:-(x::Number, r1::AbstractRating{T}) where {T <: Number} = value(r1) - x

Base.:*(r1::AbstractRating{T}, x::Number) where {T <: Number} = value(r1) * x
Base.:*(x::Number, r1::AbstractRating{T}) where {T <: Number} = value(r1) * x

Base.:/(r1::AbstractRating{T}, x::Number) where {T <: Number} = value(r1) / x
Base.:/(x::Number, r1::AbstractRating{T}) where {T <: Number} = value(r1) / x

Base.isequal(r1::AbstractRating{T}, x::Number) where {T <: Number} = value(r1) == x
Base.:!=(r1::AbstractRating{T}, x::Number) where {T <: Number} = value(r1) == x
