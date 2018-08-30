module Persa

# package code goes here
import Base: convert, promote_rule

struct ID
    value::Int
end

struct Rating{T <: Number}
    user::ID
    item::ID
    value::T
end

Rating(user, item, value::T) where T <: Number = Rating{T}(user, item, value)

struct Dataset{T <: Number}
    ratings::Array{Rating{T}}
end

Base.promote_rule(::Type{ID}, ::Type{Int}) = ID
Base.convert(::Type{Persa.ID}, x::Int) = Persa.ID(x)
end # module
