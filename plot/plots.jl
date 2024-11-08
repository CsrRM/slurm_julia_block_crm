## Header
using Pkg
Pkg.activate(".")
Pkg.instantiate()
using CairoMakie
using JLD2
## Plot example 
function plot_LDOS(path)
    data = load(path)
    LDOS = data["LDOS"]
    #params = data["params"]
    Φrng = data["Φrng"]
    ωrng = data["ωrng"]
    Zs = data["Zs"]
    LDOS = Dict([Z => LDOS[Z] for Z in Zs])
    fig = Figure()
    ax = Axis(fig[1, 1], xlabel = "Φ", ylabel = "ω",)
    heatmap!(ax, Φrng, ωrng, sum(values(LDOS)); colormap = :thermal, colorrange = (1e-4, 200))
    return fig
end

Vshift = "-0.10"

path = "Figures/mu(x).pdf"
mkpath(dirname(path))
fig = plot_LDOS("data/mu(0.2).jld2")
#save(figname, fig)
fig


##

# Create an observable for time
time = Observable(0.0)

# Initialize the figure
fig = Figure()
ax = Axis(fig[1, 1], xlabel = "Φ", ylabel = "ω")

# Initial loading of data
path = "data/mu($(time[])0).jld2"
data = load(path)
LDOS = data["LDOS"]
Φrng = data["Φrng"]
ωrng = data["ωrng"]
Zs = data["Zs"]
LDOS = Dict([Z => LDOS[Z] for Z in Zs])

# Create an initial heatmap
heatmap = heatmap!(ax, Φrng, ωrng, sum(values(LDOS)); colormap = :thermal, colorrange = (1e-4, 200))

# Animation parameters
framerate = 15
timestamps = range(-0.50, 1.00, step = 0.10)

# Record the animation
record(fig, "animation.mp4", timestamps; framerate = framerate) do t
    time[] = t
    path = "data/mu($(time[])).jld2"
    println("Loading data from: $path")

    # Load new data for the current timestamp
    data = load(path)
    LDOS = data["LDOS"]
    Zs = data["Zs"]
    LDOS = Dict([Z => LDOS[Z] for Z in Zs])

    # Update the heatmap data
    heatmap!(ax, Φrng, ωrng, sum(values(LDOS)); colormap = :thermal, colorrange = (1e-4, 200))
end

path = "Gifs/mu($(time[])).pdf"
mkpath(dirname(path))
#save(figname, fig)
