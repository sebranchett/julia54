using Distributed

addprocs(XX-1)
no_procs = nprocs()

total_t = 100000
t_per_proc = ifelse(total_t%no_procs==0, total_t÷no_procs, total_t÷no_procs + 1)
@everywhere t = t_per_proc
real_t = no_procs * t

@everywhere using Pkg
@everywhere Pkg.activate(".")
@everywhere using LinearAlgebra
@everywhere using StatsBase
using BenchmarkTools

@everywhere function stochastic(β=2, n=200)
    h = n^-(1/3)
    x = 0:h:10
    N = length(x)
    d = (-2/h^2 .-x) + 2sqrt(h*β)*randn(N)  # diagonal
    e = ones(N-1)/h^2  # subdiagonal
    eigvals(SymTridiagonal(d, e))[N]  # smallest negative eigenvalue
end    

@everywhere function disttloop(t=10)
    for β=[1, 2, 4, 10, 20]
        z = @distributed (+) for p = 1:no_procs
            fit(Histogram, [stochastic(β) for i=1:t], -4:0.01:1).weights
        end
    end
end

println("-----------------------------------")
println("Number of procs is $no_procs, total number of points is $real_t")
println("-----------------------------------")
@time @benchmark disttloop($t)
println("-----------------------------------")
