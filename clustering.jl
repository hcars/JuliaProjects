using FileIO, ImageMagick
#Hardcoded script to download paintings
function retrievePhotos()
    for i=1:411
        download(string("https://www.twoinchbrush.com/images/painting", i, ".png"), string("./paintings/" ,i, ".png"))
    end
end



retrievePhotos()

using Clustering, Images, Plots, FileIO
imgs = Vector{Matrix}()
for i=1:271
    try
    imgs[i] = push!(imgs, load(File(format"PNG", string("paintings", "\\", i, ".png"))))
    catch e
        # println(e)
 end
end

loaded

imgs

imgsFlattend = map(x->reshape(x, 151650), imgs)
toCluster = Matrix{Normed{UInt8, 8}}(undef, (454950, 266))
@inbounds for j=1:266
                for i=1:151650
                    toCluster[1 + ((i-1)*3), j] = imgsFlattend[j][i].r
                    toCluster[2 + ((i-1)*3), j] = imgsFlattend[j][i].g
                    toCluster[3 + ((i-1)*3), j] = imgsFlattend[j][i].b
                end
            end
toCluster
kmeansArr = Vector{KmeansResult}()
@inbounds for k=2:10
    push!(kmeansArr, kmeans(toCluster, k; maxiter=300))
end
@inbounds for k=11:12
    push!(kmeansArr, kmeans(toCluster, k; maxiter=300))
end
using Statistics
costs = map(x->x.totalcost, kmeansArr)
μ = mean(costs)
σ = Statistics.std(costs)
plot(2:16, map(x-> (x.totalcost - μ)/ σ , kmeansArr))



plot(2:10, map(x-> x.totalcost , kmeansArr))
kmeansArr[7].centers
kmeansArr
function deflatten( flat :: Array{Float32, 2})
        rgb = Array{RGB{Normed{UInt8,8}},1}(undef, 151650)
    @inbounds for i=1:151650
                    rgb[i] = RGB(N0f8(flat[1 + ((i-1)*3)]), N0f8(flat[2 + ((i-1)*3)]), N0f8(flat[3 + ((i-1)*3)]))
                end
        image = Array{RGB{N0f8},2}(undef, 337, 450)
        lower = 1
        upper = 337
    @inbounds for j=1:450
                image[:, j] = rgb[lower:upper]
                lower += 337
                upper += 337
        end
        return image
    end
for i=1:9
    for j=1:size(kmeansArr[i].centers)[2]
        save(File(format"PNG", string("art\\clustering", i, "center", j, "abstract.png")), deflatten(view(kmeansArr[i].centers, :, j)))
    end
end
