immutable Weight
  value::Float64
  c::Bool
  intersect::Int
end

type Similarity
  w::Array{Weight,2}
  matrix::SparseMatrixCSC
  elements::Int
  iscalculated::Array{Bool,1}
  k::Int
  γ::Int

  Similarity() = new()
  Similarity(w::Array{Weight,2}, matrix::SparseMatrixCSC, elements::Int, iscalculated::Array{Bool,1}, k::Int, γ::Int) = new(w, matrix, elements, iscalculated, k, γ)
end

Weight() = Weight(NaN, false, 0)

function Similarity{T<:CFDatasetAbstract}(dataset::T, k::Int; γ = 10)
  elements = dataset.users

  w = Array{CollaborativeFiltering.Weight,2}(elements, elements)

  for i=1:minimum(size(w))
    for j=1:maximum(size(w))
      w[i,j] = CollaborativeFiltering.Weight()
    end
  end

  for i=1:elements
      w[i,i] = Weight(NaN, true, false)
  end

  matrix = getMatrix(dataset)

  return Similarity(w, matrix, elements, fill(false, elements), k, γ)
end

iscalculate(w::Weight) = w.c

function isNeighbor(similarity::Similarity, a::Int, b::Int)
  if !iscalculate(similarity.w[a,b])
    calculateWeight!(similarity, a, b)
  end

  return similarity.w[a,b].intersect >= similarity.k
end

function calculateWeight!(similarity::Similarity, i::Int, j::Int)
  inter = length(intersectRatings(similarity.matrix[i,:], similarity.matrix[j,:]))

  if inter >= similarity.k
    value = significanceWeighting(similarity.matrix[i, :], similarity.matrix[j, :], cosine; γ = similarity.γ)
  else
    value = NaN
  end

  similarity.w[i,j] = Weight(value, true, inter)
  similarity.w[j,i] = similarity.w[i,j]
end

Base.length(similarity::Similarity) = similarity.elements

function Base.getindex(similarity::Similarity, i, j)
  if isNeighbor(similarity, i, j)
    return similarity.w[i,j].value
  end

  return NaN
end

function getWeights(similarity::Similarity, user::Int, item::Int)
  neighbours = similarity[user]
  neighbours_who_view_item = Tuple{Int, Float64}[]

  for i=1:length(neighbours)
    if similarity.matrix[neighbours[i][1], item] > 0
      push!(neighbours_who_view_item, neighbours[i])
    end
  end

  return neighbours_who_view_item
end

function Base.getindex(similarity::Similarity, i)
  if !similarity.iscalculated[i]
    for j=1:length(similarity)
        similarity[i, j]
    end
    similarity.iscalculated[i] = true
  end

  x = Tuple{Int, Float64}[]

  for j=1:similarity.elements
    value = similarity[i,j]
    if !isnan(value)
      push!(x, (j, value))
    end
  end

  return x
end

function cosine(a,b)
    if sum(a) == 0 || sum(b) == 0
        return 0;
    end

    return sum(a .* b) ./ (sqrt(sum(a.^2)) * sqrt(sum(b.^2)))
end

function unionCosine(a,b)
  index = intersect(find(r-> r != 0, a), find(r-> r != 0, b));
  if length(index) < 2
    return 0;
  else
    return cosine(a[index], b[index]);
  end
end

function pearsonCorrelation(a,b)
  index_a = find(r-> r != 0, a)
  index_b = find(r-> r != 0, b)

  index = intersect(index_a, index_b)

  if length(index) < 2
    return 0;
  end

  norm_a = a[index] .- mean(a[index_a])
  norm_b = b[index] .- mean(b[index_b])

  y = sqrt(sum(norm_a .^ 2)) .* sqrt(sum(norm_b .^ 2))

  if y == 0
    return 0
  end

  return sum(norm_a .* norm_b) ./ y
end

intersectRatings(a, b) = intersect(find(r-> r != 0, a), find(r-> r != 0, b))

significanceWeighting(a, b, similarity::Function; γ = 10) = similarity(a,b) .* (min(γ, maximum(size(intersectRatings(a, b)))) ./ γ)
