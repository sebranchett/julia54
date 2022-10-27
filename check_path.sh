#!/bin/bash

#SBATCH --job-name=julia54
#SBATCH --partition=compute
#SBATCH --account=research-uco-ict
#SBATCH --time=00:10:00
#SBATCH --ntasks=1
#SBATCH --cpus-per-task=1
#SBATCH --mem-per-cpu=1GB

# find your account with:
# sacctmgr list -sp user $USER

module load 2022r2
module load julia
srun julia --project=. -e 'println(DEPOT_PATH)' > check_path.log
