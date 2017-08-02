Base.mean{T<:CFDatasetAbstract}(dataset::T) = mean(dataset.file[:rating])

function shrunkUserMean(dataset::CFDatasetAbstract, α::Int)
  b = zeros(Float64, dataset.users)

  matrix = getmatrix(dataset)

  μ = mean(dataset)

  for i=1:dataset.users
    index = find(r->r != 0, matrix[i, :])

    b[i,1] = ((α * μ) / (α * length(index))) + (length(index) * mean(matrix[i, index]) / (α + length(index)))
  end

  return b
end

function shrunkItemMean(dataset::CFDatasetAbstract, α::Int)
  b = zeros(Float64, dataset.items)

  matrix = getmatrix(dataset)

  μ = mean(dataset)

  for i=1:dataset.items
    index = find(r->r != 0, matrix[:, i])

    b[i,1] = ((α * μ) / (α * length(index))) + (length(index) * mean(matrix[index, i]) / (α + length(index)))
  end

  return b
end
