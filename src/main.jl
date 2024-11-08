using JLD2
@everywhere begin
    using Quantica
    using FullShell
    using Parameters
    using ProgressMeter
    include("calc_muxLDOS.jl")
    include("parallelizers.jl")
end

## Run

calc_muxLDOS(0.0)

#save("data/LDOS.jld2", "LDOS", LDOS)
