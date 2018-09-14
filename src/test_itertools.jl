using IterTools
using BenchmarkTools

struct Window{T}
    xs::T
    width::Int
    offset::Int
    equal_size::Bool #default = true
end

function Window(xs, width::Int, offset::Int; equal_size = true)
    if width < 0
        error("width must be greater than 0")
    end
    if offset < 0
        error("offset mus be greater than 0")
    end
    return Window(xs, width, offset, equal_size)
end

Base.IteratorSize(it::Window) = Base.SizeUnknown()
Base.eltype(it::Window{T}) where T = Vector{eltype(T)}

function Base.iterate(it::Window{T}, state = 1) where T <: AbstractVector
    if state + it.width - 1 <= length(it.xs)
        return (it.xs[state:(state + it.width - 1)], state + it.offset)
    elseif !it.equal_size && state < length(it.xs)
        return (it.xs[state:end], state + it.offset)
    else
        return nothing
    end
end



event_times = 1:10

pw = Window(event_times, 3, 1)
pw = Window(enumerate(1:100), 3, 1)
pw.xs[1]
for w in pw
    @show w
end
collect(pw)

collect(partition(event_times, 3, 1))

@btime collect(Window($event_times, 2, 1));
@btime collect(partition($event_times, 2, 1));

@time collect(Window(1:1000, 2, 1));
@time collect(partition(1:1000, 2, 1));

@code_warntype collect(Window(event_times, 2, 1));
@code_warntype collect(partition(event_times, 2, 1));
