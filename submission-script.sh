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
# py-matplotlib is needed to load the libiomp5.so library (workaround)
module load py-matplotlib

# this avoids the 'qt.qpa.xcb: could not connect to display' error
export QT_QPA_PLATFORM="offscreen"

# first time with new Project.toml, run this on the login node:
# julia --project=. -e "using Pkg; Pkg.instantiate()"

srun julia --project=. Julia-fresh-54.jl > output.log
