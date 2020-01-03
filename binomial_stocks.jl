function createPath(S :: Float64, r::Float64, sigma::Float64, T::Float64, n :: Int64)
        path = Array{Float64, 1}(undef, n + 1)
        path[1] = S
        h = T / n
        d = MathConstants.e^(r*h - sigma * √(h))
        u = MathConstants.e^(r*h + sigma * √(h))
        p = (MathConstants.e^(r*h) - d) / (u - d)
        for i=2:n+1
                if rand() < p
                        S *= u
                else
                        S *= d
                end
                path[i] = S
        end
        path
end
S=100.0;
T=1.0;
n=10000;
σ=0.3;
r=0.08;

using Plots
createPath(S,r,σ, T, n)
plt = plot(createPath(S,r,σ, T, n))
Threads.@threads for i=2:10
        plot!(plt, createPath(S,r,σ, T, n))
end
plot!(plt)
using Distributions
# function priceCDF(price :: Float64, S :: Float64, r::Float64, sigma::Float64, T::Float64, n :: Int64)
#         h = T/n
#         d = MathConstants.e^(r*h - sigma * √(h))
#         u = MathConstants.e^(r*h + sigma * √(h))
#         p = (MathConstants.e^(r*h) - d) / (u - d)
#         cnt = 0
#         while S < price
#
#         cdf(Binomial(n, p), price)
# end

# priceCDF(200.0, S,r,σ, T, n)
function finalDist(S :: Float64, r::Float64, sigma::Float64, T::Float64, n :: Int64)
        h = T / n
        d = MathConstants.e^(r*h - sigma * √(h))
        u = MathConstants.e^(r*h + sigma * √(h))
        p = (MathConstants.e^(r*h) - d) / (u - d)
        finalPrices = Array{Float64, 1}(undef, n+1)
        probs = Array{Float64, 1}(undef, n+1)
        for i=0:length(finalPrices) - 1
                finalPrices[i+1] = (u^(n-i))*(d^i)*S
                probs[i + 1] = binomial(BigInt(n), BigInt(n-i)) * (p^(n-i)) * ((1-p)^i)
        end
        # uniquePrice = unique(finalPrices)
        # finalProbs = Array{Float64, 1}(undef, length(uniquePrice))
        # @inbounds for i in eachindex(uniquePrice)
        #                 for j in eachindex(finalPrices)
        #                         if finalPrices[j] == uniquePrice[i]
        #                                 finalProbs[i] += probs[j]
        #                         end
        #                 end
        #         end
        return finalPrices, probs
end

scatter(finalDist(S,r,σ, T, 100))

r=.001
σ = .001
T=10.0
scatter(finalDist(S,r,σ, T, 100))
