using Distributed
using LinearAlgebra
using Pkg
Pkg.add("PyPlot")
Pkg.add("StatsBase")
using PyPlot
using StatsBase

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
for β=[1, 2, 4, 10, 20]
    z = fit(Histogram, [stochastic(β) for i=1:t], -4:0.01:1).weights
    plot(midpoints(-4:0.01:1), z/sum(z)/0.01)
end
title("DelftBlue Sequential version")
savefig("sequential_version.png")
