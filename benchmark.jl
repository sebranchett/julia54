using Distributed

addprocs(10)
no_procs = nprocs()

@everywhere using Pkg
@everywhere Pkg.activate(".")
@everywhere using LinearAlgebra
@everywhere using StatsBase
@everywhere using BenchmarkTools

function stochastic(β=2, n=200)
    h = n^-(1/3)
    x = 0:h:10
    N = length(x)
    d = (-2/h^2 .-x) + 2sqrt(h*β)*randn(N)  # diagonal
    e = ones(N-1)/h^2  # subdiagonal
    eigvals(SymTridiagonal(d, e))[N]  # smallest negative eigenvalue
end    

function tloop(t=10)
    for β=[1, 2, 4, 10, 20]
        z = fit(Histogram, [stochastic(β) for i=1:t], -4:0.01:1).weights
    end
end

@everywhere function diststochastic(β=2, n=200)
    h = n^-(1/3)
    x = 0:h:10
    N = length(x)
    d = (-2/h^2 .-x) + 2sqrt(h*β)*randn(N)  # diagonal
    e = ones(N-1)/h^2  # subdiagonal
    eigvals(SymTridiagonal(d, e))[N]  # smallest negative eigenvalue
end    

@everywhere function disttloop(t=10)
    for β=[1, 2, 4, 10, 20]
        z = @distributed (+) for p = 1:nprocs()
            fit(Histogram, [diststochastic(β) for i=1:t], -4:0.01:1).weights
        end
    end
end

@everywhere function instabstochastic()
    h = n^-(1/3)
    x = 0:h:10
    N = length(x)
    d = (-2/h^2 .-x) + 2sqrt(h*β)*randn(N)  # diagonal
    e = ones(N-1)/h^2  # subdiagonal
    eigvals(SymTridiagonal(d, e))[N]  # smallest negative eigenvalue
end    

@everywhere function instabtloop()
    for β=[1, 2, 4, 10, 20]
        z = @distributed (+) for p = 1:nprocs()
            fit(Histogram, [instabstochastic() for i=1:t], -4:0.01:1).weights
        end
    end
end

@everywhere t = 10000

println("Sequential version-----------------")
println("-----------------------------------")
println("stochastic-------------------------")
@code_warntype stochastic(2, 200)
println("tloop------------------------------")
@code_warntype tloop(t)
println("btime------------------------------")
@btime tloop(t)
println("-----------------------------------")

println("distributed version----------------")
println("-----------------------------------")
println("stochastic-------------------------")
@code_warntype diststochastic(2, 200)
println("tloop------------------------------")
@code_warntype disttloop(t)
println("btime------------------------------")
@btime disttloop(t)
println("-----------------------------------")

@everywhere β=2
@everywhere n=200
println("type instability version-----------")
println("-----------------------------------")
println("stochastic-------------------------")
@code_warntype instabstochastic()
println("tloop------------------------------")
@code_warntype instabtloop()
println("btime------------------------------")
@btime instabtloop()
println("-----------------------------------")
