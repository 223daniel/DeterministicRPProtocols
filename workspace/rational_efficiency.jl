using Plots

include("rational.jl")

function efficiency_limit(d, c, dist, k_max)
    efficiency_vector = zeros(Float64, k_max)

    # Entropies
    consumption_entropy = log(2, d)
    production_entropy = sum( map(x -> -x/d * log(2, (x/d)), dist) )

    A = map( x -> [x], dist ) # alpha^k in base d

    # k = 1 special case
    # Consume & produce 1 digit each round
    efficiency_vector[1] = production_entropy / consumption_entropy

    for k in 2:k_max

        # New base representations of alpha^k
        # Digits read backwards
        next_A = Vector{Vector{Int}}()
        for j = 1:c
            append!(next_A, A * dist[j])
        end
        # Carries
        for num in next_A
            for i = 1:length(num)-1
                if num[i] >= d
                    (q, r) = divrem(num[i], d)
                    num[i] = r
                    num[i+1] += q
                end
            end
            # Special case first digit 
            if num[end] >= d
                (q, r) = divrem(num[end], d)
                num[end] = r
                append!(num, q)
            end
        end
        A = next_A
        # Base summations
        sum_bases = zeros(Int, k)
        for num in A
            for i = 1:length(num)
                sum_bases[i] += num[i]
            end
        end

        # Calculate expected digits consumed
        expected_in = 0
        for i = 1:k
            expected_in += (k-i+1) * sum_bases[i] / d^(k-i+1)
        end

        expected_out = k
        efficiency_vector[k] = (production_entropy * expected_out) / (consumption_entropy * expected_in)
    end
    
    return efficiency_vector
end

# rational.a
# Edit variables here
d = 17
c = 4
dist = [2;3;5;7]
k_max = 10

plotlyjs()
vec1 = efficiency_limit(d, c, dist, k_max)
vec2 = [1 - 1/k for k in 1:k_max]
plot(vec1)
plot!(vec2)
println(vec1)
xlims!((0,k_max))
ylims!((0,1))
savefig(string("plot_rational_", d, "_", c ,"_", k_max, ".png"))