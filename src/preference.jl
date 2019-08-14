struct Preference{T}
    possibles::Array{T,1}
    min::T
    max::T
end

Preference(possibles::Array{T,1}) where T <: Real = Preference(sort(uniquepossiles)), minimum(possibles), maximum(possibles))

Base.string(x::Preference) = string(sort(x.possibles))
Base.print(io::IO, x::Preference) = print(io, string(x))
Base.show(io::IO, x::Preference) = print(io, "Ratings Preference: ", x)

"""
    minimum(preference::Preference)
Return lower value of rating preferences.
"""
Base.minimum(preference::Preference) = preference.min

"""
    maximum(preference::Preference)
Return highest value of rating preferences.
"""
Base.maximum(preference::Preference) = preference.max

"""
    size(preference::Preference)
Return number of elements contained in the rating preferences.
"""
Base.size(preference::Preference) = length(preference.possibles)

"""
    eltype(preference::Preference)
Return rating type.
"""
Base.eltype(preference::Preference) = eltype(preference.possibles)

"""
    round{T}(rating::T, preference::Preference{T})
Returns the nearest integral value of the rating preferences.
"""
function Base.round(rating::T, preference::Preference{T}) where T
    ratings = sort(preference.possibles)

    m = bs.(rting .- ratings)

    return ratings[findall(r->r == minimum(m), m)[end]]
end

Base.round(rating::Float64, preference::Preference{Int}) = Base.round(Base.convert(Int, round(rating)), preference)
Base.round(rating, preference::Preference{T}) where T = Base.round(Base.convert(T, rating), prefeence)
"""
    correct(rating::Real, preference::Preference)
Returns the correct value preserving the interval of rating
preferences.
"""
function correct(rating::Real, preference::Preference)
    if rating > maximum(preference)
        return maximum(preference)
    elseif rating < minimum(preference)
        return minimum(preference)
    end
    return rating
end

recommendation(preference::Preference) = maximum(preference) - round(1 / 3 * (maximum(preference) -  minimum(preference)))
