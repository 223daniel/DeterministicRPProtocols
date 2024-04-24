using Plots

include("uniform.jl")

function efficiency_limit(d, c, k_max)
    efficiency_vector = zeros(Float64, k_max)
    for k in 1:k_max
        num_leaves = d^k

        if d^k < c
            efficiency_vector[k] = 0
            continue
        end
        consumption_entropy = log(2, d) * k

        n = 0
        index = 0 # number of populated leaves
        while index < num_leaves
            # Find largest power of c that is less than remaining leaves
            # i.e. length of output
            m = floor(Int, log(c, num_leaves - index))
            output_length = c^m
            # uhh
            while num_leaves - index >= output_length
                n += m * output_length
                index += output_length
            end
        end

        production_entropy = log(2, c) * n / num_leaves
        efficiency_vector[k] = production_entropy / consumption_entropy
    end    
    
    return efficiency_vector
end

# uniform.a
# list of tuples (d,c) where d is the size of input dist and c is the size of output dist
d_c_pairs = [
    (2, 3);
    (2, 4);
    (3, 2);
    (3, 4);
    (3, 5);
    (3, 6);
    (4, 2);
    (4, 3);
]
# uniform.b
# iterates from k = 1 (one input bit per round) to k = k_max
k_max = 50 
plotlyjs()
for pair in d_c_pairs
    vec1 = efficiency_limit(pair[1], pair[2], k_max)
    vec2 = [1 - 1/k for k in 1:k_max]
    plot(vec1)
    plot!(vec2)
    println(vec1)
    xlims!((0,50))
    ylims!((0,1))
    savefig(string("plot_uniform_", pair[1], "_", pair[2], "_", k_max, ".png"))
end