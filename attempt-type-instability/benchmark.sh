#!/bin/bash

#SBATCH --job-name=julia54
#SBATCH --partition=compute
#SBATCH --account=research-uco-ict
#SBATCH --time=00:10:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=11
#SBATCH --mem-per-cpu=1GB

# find your account with:
# sacctmgr list -sp user $USER

module load 2022r2
module load julia

# first time with new Project.toml, run this on the login node:
# julia --project=. -e "using Pkg; Pkg.instantiate()"

srun julia --project=. < benchmark.jl > benchmark.log
