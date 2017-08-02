Base.mean{T<:CFDatasetAbstract}(dataset::T) = mean(dataset.file[:rating])

function shrunkUserMean(dataset::CFDatasetAbstract, α::Int)
  b = zeros(Float64, dataset.users)

  matrix = getMatrix(dataset)

  μ = mean(dataset)

  for i=1:dataset.users
    index = find(r->r != 0, matrix[i, :])

    b[i,1] = ((α * μ) / (α * length(index))) + (length(index) * mean(matrix[i, index]) / (α + length(index)))
  end

  return b
end

function shrunkItemMean(dataset::CFDatasetAbstract, α::Int)
  b = zeros(Float64, dataset.items)

  matrix = getMatrix(dataset)

  μ = mean(dataset)

  for i=1:dataset.items
    index = find(r->r != 0, matrix[:, i])

    b[i,1] = ((α * μ) / (α * length(index))) + (length(index) * mean(matrix[index, i]) / (α + length(index)))
  end

  return b
end

function histogram(ds::Persa.CFDatasetAbstract; mode::Symbol = :global)
  @assert in(mode, [:user, :item, :global]) "Incorrect mode. Use :user, :item or :global."

  if mode == :user
    return histogram_user(ds)
  elseif mode == :item
    return histogram_item(ds)
  else
    return histogram_global(ds)
  end
end

function histogram_global(ds::Persa.CFDatasetAbstract)
  hist = Dict{eltype(ds.preferences), Int64}()

  for i in Persa.possiblesratings(ds)
    hist[i] = 0
  end

  for (u, v, r) in ds
    hist[r] += 1
  end

  return hist
end

function histogram_user(ds::Persa.CFDatasetAbstract)
  hist = Dict{Int64, Dict{eltype(ds.preferences), Int64}}()

  for i = 1:ds.users
    hist[i] = Dict{eltype(ds.preferences), Int64}()
    for j in Persa.possiblesratings(ds)
      hist[i][j] = 0
    end
  end

  for (u, v, r) in ds
    hist[u][r] += 1
  end

  return hist
end

function histogram_item(ds::Persa.CFDatasetAbstract)
  hist = Dict{Int64, Dict{eltype(ds.preferences), Int64}}()

  for i = 1:ds.items
    hist[i] = Dict{eltype(ds.preferences), Int64}()
    for j in Persa.possiblesratings(ds)
      hist[i][j] = 0
    end
  end

  for (u, v, r) in ds
    hist[v][r] += 1
  end

  return hist
end
