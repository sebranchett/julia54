using Distributed
using LinearAlgebra
using StatsBase
using Plots

function stochastic(β=2, n=200)
    h = n^-(1/3)
    x = 0:h:10
    N = length(x)
    d = (-2/h^2 .-x) + 2sqrt(h*β)*randn(N)  # diagonal
    e = ones(N-1)/h^2  # subdiagonal
    eigvals(SymTridiagonal(d, e))[N]  # smallest negative eigenvalue
end    

println("Sequential version")
t = 10000
plot(title="DelftBlue Sequential version")
for β=[1, 2, 4, 10, 20]
    z = fit(Histogram, [stochastic(β) for i=1:t], -4:0.01:1).weights
    plot!(midpoints(-4:0.01:1), z/sum(z)/0.01, label="β = $β")
end
savefig("delftblue_sequential_version.png")

# Readily adding more processors sharpens the Monte Carlo simulation,
# computing 1024 times as many samples in hte same time

addprocs(10)
no_procs = nprocs()

@everywhere using LinearAlgebra

# StatsBase is not a standard package, so need to activate the environment first
@everywhere using Pkg
@everywhere Pkg.activate(".")
@everywhere using StatsBase

# same as cell 2, but with @everywhere in front
@everywhere function stochastic(β=2, n=200)
    h = n^-(1/3)
    x = 0:h:10
    N = length(x)
    d = (-2/h^2 .-x) + 2sqrt(h*β)*randn(N)  # diagonal
    e = ones(N-1)/h^2  # subdiagonal
    eigvals(SymTridiagonal(d, e))[N]  # smallest negative eigenvalue
end    

println("@distributed version")
@everywhere t = 10000
plot(title="DelftBlue Distrubuted version with nprocs = $no_procs")
for β=[1, 2, 4, 10, 20]
    z = @distributed (+) for p = 1:nprocs()
        fit(Histogram, [stochastic(β) for i=1:t], -4:0.01:1).weights
    end
    plot!(midpoints(-4:0.01:1), z/sum(z)/0.01, label="β = $β")
end
savefig("delftblue_distributed_version.png")
