#### Prepare Data For Regression Problem

X = rand(1000, 3)               # feature matrix
a0 = rand(3)                    # ground truths
y = X * a0 + 0.1 * randn(1000);  # generate response

# Data For Regression Problem Part 2
X= rand(Float64, 2000, 2)
y = X * [2.0, 3.0]  .+ randn(2000) .+ 100;
using  Plots, LinearAlgebra
function fit(X :: Array{T}, y :: Array{T, 1}, include_bias=false) where T <: Real
    if include_bias
        if ndims(X) > 1
            new_X = Array{T}(undef, size(X)[1], (size(X)[2] + 1))
            new_X[:, 1 : (size(X)[2])] = view(X, :, :)
            new_X[:,size(X)[2] + 1]= ones(size(new_X)[1])
        else
            new_X = Array{T}(undef, length(X), 2)
            new_X[:, 1] = view(X, :)
            new_X[:, 2] = ones(length(X))
        end
        X =new_X
    end
        β = pinv(transpose(X)* X)*(transpose(X) * y)
    return β
end


β = fit(X, y, true)
y_pred =  X * β[1:2] .+ β[3]
plt = plot(y_pred)
scatter!(plt, y)
xaxis!(plt, X)
