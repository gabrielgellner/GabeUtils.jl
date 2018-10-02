import LinearAlgebra.I

idmatrix(n::Int) = Matrix{Float64}(I, n, n)

seq(start, stop; length = nothing) = range(start, stop = stop, length = length)
