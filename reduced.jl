using LinearAlgebra
using StatsBase
using Plots

ENV["QT_QPA_PLATFORM"]="offscreen"
function stochastic(β=2, n=20)
    h = n^-(1/3)
    x = 0:h:10
    N = length(x)
    d = (-2/h^2 .-x) + 2sqrt(h*β)*randn(N)  # diagonal
    e = ones(N-1)/h^2  # subdiagonal
    eigvals(SymTridiagonal(d, e))[N]  # smallest negative eigenvalue
end    

println("Sequential version")
t = 100
plot(title="DelftBlue Sequential version")
for β=[1, 2]
    z = fit(Histogram, [stochastic(β) for i=1:t], -4:0.01:1).weights
    plot!(midpoints(-4:0.01:1), z/sum(z)/0.01, label="β = $β")
end
savefig("delftblue_sequential_version.png")
