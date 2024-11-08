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

Vshift = 0.2

path = "figures/mu($Vshift).pdf"
mkpath(dirname(path))
fig = plot_LDOS("data/mu($Vshift).jld2")
#save(figname, fig)
fig