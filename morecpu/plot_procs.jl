using DataFrames
using CSV
using Plots

if size(ARGS)[1] < 1
    println(" Please supply a CSV filename, e.g.:")
    println("julia --project=. plot_procs.jl parsed.csv")
    exit()
end

filename = ARGS[1]
data = DataFrame(CSV.File(filename; delim=", "))
# column_names = names(data)

# select first 10 data points
data = first(data, 10)

plot(title="DelftBlue time vs. number of procs", xlabel="Number of procs")
plot!(data."Number of procs", data."@time seconds", label="@time seconds")
plot!(data."Number of procs", data."@benchmark time s", label="@benchmark time s")

savefig("delftblue_time_vs_procs.png")
