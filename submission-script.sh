#!/bin/bash

#SBATCH --job-name=julia54
#SBATCH --partition=compute
#SBATCH --account=research-uco-ict
#SBATCH --time=00:10:00
#SBATCH --ntasks=11
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1GB

# find your account with:
# sacctmgr list -sp user $USER

module load 2022r2
module load julia
srun julia Julia-fresh-54.jl --project=. > output.log
