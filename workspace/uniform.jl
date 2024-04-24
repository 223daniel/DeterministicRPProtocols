
# Protocol Struct
mutable struct UniformProtocol
    d::Int
    c::Int
    k::Int
    state::Vector{Int}
    output_array::Vector{Vector{Int}}
    efficiency::Number
end

# Instantiate the protocol
function initialize_uniform_protocol(d = 3, c = 2, k = 2)
    # d^k -> # of leaves
    num_leaves = d^k
    
    ##### Perform sanity check on k #####
    # if num_leaves < c, then throw an error or something
    if num_leaves < c
        return nothing
    end

    consumption_entropy = log(2, d) * k
    array, production_entropy = build_output_array(num_leaves, c)
    return UniformProtocol(d, c, k, Vector{Int}(), array, production_entropy / consumption_entropy)
end

# Main runner of protocol
function step_uniform_protocol(protocol::UniformProtocol, input::Int) 
    result = Vector{Int}()
    protocol.state = push!(protocol.state, input)
    if length(protocol.state) == protocol.k
        # Base conversion logic to identify index
        index = foldl((x,y) -> protocol.d * x + y, protocol.state) + 1
        result = protocol.output_array[index]
        protocol.state = Vector{Int}()
    end
    return result
end

# Returns an array with d^k output vectors, one for each leaf of the protocol
function build_output_array(num_leaves::Int, c::Int)
    result = Vector{Vector{Int}}()
    n = 0;

    index = 0 # number of populated leaves
    while index < num_leaves
        # Find largest power of c that is less than remaining leaves
        # i.e. length of output
        m = floor(Int, log(c, num_leaves - index))
        output_length = c^m
        m_length_output = generate_output(c, m)
        # uhh
        while num_leaves - index >= output_length
            n += m * output_length
            append!(result, m_length_output)
            index += output_length
        end
    end

    production_entropy = log(2, c) * n / num_leaves;
    return result, production_entropy
end

# Returns a vector populated with m-length c-ary output vectors
function generate_output(c::Int, m::Int)
    result = [[]]
    # i-length c-ary output string
    for i = 1:m
        i_length_vectors = Vector{Vector{Int}}()
        for vec in result
            for j in 0:c-1
                push!(i_length_vectors, push!(copy(vec), j))
            end
        end
        result = i_length_vectors
    end
    
    return result
end