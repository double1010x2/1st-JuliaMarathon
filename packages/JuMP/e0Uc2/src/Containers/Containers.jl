#  Copyright 2017, Iain Dunning, Joey Huchette, Miles Lubin, and contributors
#  This Source Code Form is subject to the terms of the Mozilla Public
#  License, v. 2.0. If a copy of the MPL was not distributed with this
#  file, You can obtain one at http://mozilla.org/MPL/2.0/.
#############################################################################
# JuMP
# An algebraic modeling language for Julia
# See http://github.com/jump-dev/JuMP.jl
#############################################################################

"""
    Containers

Module defining the containers `DenseAxisArray` and `SparseAxisArray` that
behaves as a regular `AbstractArray` but with custom indexes that are not
necessarily integers.
"""
module Containers

# Arbitrary typed indices. Linear indexing not supported.
struct IndexAnyCartesian <: Base.IndexStyle end
Base.IndexStyle(::IndexAnyCartesian, ::IndexAnyCartesian) = IndexAnyCartesian()

export DenseAxisArray, SparseAxisArray

include("DenseAxisArray.jl")
include("SparseAxisArray.jl")

Base.eachindex(g::Base.Generator{<:Union{DenseAxisArray, SparseAxisArray}}) = eachindex(g.iter)

# The generic implementation uses `LinearIndices` which is not supported by
# `DenseAxisArray` and `SparseAxisArray`.
function Base.collect_to_with_first!(
    dest::Union{DenseAxisArray, SparseAxisArray},
    first_value, iterator, state
)
    indices = eachindex(iterator)
    dest[first(indices)] = first_value
    for index in Iterators.drop(indices, 1)
        element, state = iterate(iterator, state)
        dest[index] = element
    end
    return dest
end

include("generate_container.jl")
include("vectorized_product_iterator.jl")
include("nested_iterator.jl")
include("no_duplicate_dict.jl")
include("container.jl")
include("macro.jl")

end
