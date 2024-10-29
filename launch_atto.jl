#!/usr/bin/env -S julia --project
## Slurm header
#SBATCH --partition=most
#SBATCH --ntasks=384
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=2G
#SBATCH --output="slurm.out/%j.out"

# Get script_path to use include
scontrol_cmd = `scontrol show job $(ENV["SLURM_JOBID"])`
awk_cmd = `awk -F'Command=' '{print $2}'`
script_path = read(pipeline(scontrol_cmd, awk_cmd), String) |> strip |> dirname

## Julia setup
using Distributed
const maxprocs = 192
addprocs(max(0, maxprocs + 1 - nworkers()))

## Run code
include("$(script_path)/src/main.jl")

## Clean up
rmprocs(workers()...)