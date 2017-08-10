"""
    Base.mean(dataset::CFDatasetAbstract)

Return global mean of collaborative filtering dataset.
"""
Base.mean(dataset::CFDatasetAbstract) = mean(dataset.file[:rating])

"""
    mean(dataset::CFDatasetAbstract)

Return global mean of collaborative filtering dataset.
"""
mean(dataset::CFDatasetAbstract) = mean(dataset)

"""
    means(dataset::CFDatasetAbstract; mode::Symbol = :user, α::Int = 0)

Return mean of each user/item.

# Arguments
- `mode::Symbol = :user`: The mode of mean.Whether the calculation will be per
  user or per item. Values [:user, :item].
- `α::Int = 0`: Shrinkage value. Shrinkage is a interpolation factor between an
  estimate computed from data and a global mean.
"""
function means(dataset::CFDatasetAbstract; mode::Symbol = :user, α::Int = 0)
    @assert in(mode, [:user, :item]) "Incorrect mode. Use :user or :item"

    if mode == :user
      return meansusers(dataset, α)
    else
      return meansitems(dataset, α)
    end
end

function meansusers(dataset::CFDatasetAbstract, α::Int)
  b = zeros(Float64, dataset.users)

  matrix = getmatrix(dataset)

  μ = mean(dataset)

  for i=1:dataset.users
    index = find(r->r != 0, matrix[i, :])

    if length(index) == 0
        b[i,1] = μ
    else
        if α == 0
            b[i,1] = (length(index) * mean(matrix[i, index]) / (α + length(index)))
        else
            b[i,1] = ((α * μ) / (α + length(index))) + (length(index) * mean(matrix[i, index]) / (α + length(index)))
        end
    end
  end

  return b
end

function meansitems(dataset::CFDatasetAbstract, α::Int)
  b = zeros(Float64, dataset.items)

  matrix = getmatrix(dataset)

  μ = mean(dataset)

  for i=1:dataset.items
    index = find(r->r != 0, matrix[:, i])

    if length(index) == 0
        b[i,1] = μ
    else
        if α == 0
            b[i,1] = (length(index) * mean(matrix[index, i]) / (α + length(index)))
        else
            b[i,1] = ((α * μ) / (α + length(index))) + (length(index) * mean(matrix[index, i]) / (α + length(index)))
        end
    end
  end

  return b
end

@deprecate shrunkItemMean(dataset::CFDatasetAbstract, α::Int) meansitems(dataset, α)
@deprecate shrunkUserMean(dataset::CFDatasetAbstract, α::Int) meansusers(dataset, α)

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
