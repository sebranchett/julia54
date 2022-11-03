# Investigate what happens when you add more procs

`time_XX.jl` is a template Julia program.

`time_XX.sh` is a template slurm submission script.

`makeandrunjob.sh` takes one argument (e.g. 02) and substitutes XX for the argument in `time_XX.jl` and `time_XX.sh`. It then submits this new job.

`parse_output.jl` is a first attempt to extract `@time` and `@benchmark` data from the output files.
