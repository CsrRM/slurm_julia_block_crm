using JLD2
@everywhere begin
    using Quantica
    using FullShell
    using Parameters
    using ProgressMeter
    include("calc_muxLDOS.jl")
    include("parallelizers.jl")
end

# Validate input parameter
if length(ARGS) < 1
    error("No parameter provided. Usage: julia main.jl <param>")
end

# Parse parameter (adjust type as needed, e.g., Float64, String, etc.)
param = parse(Float64, ARGS[1])  # Example for a floating-point parameter

## Run

calc_muxLDOS(param)

#save("data/LDOS.jld2", "LDOS", LDOS)
