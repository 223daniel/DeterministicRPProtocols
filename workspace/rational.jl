
mutable struct TreeNode
    string::Vector{Int}
    leaf::Bool
    children::Vector{TreeNode}
end

mutable struct RationalProtocol
    d::Int
    c::Int
    dist::Vector{Int}
    k::Int
    root::TreeNode
    state::TreeNode
    efficiency::Number
end

function initialize_rational_protocol(d::Int, c::Int, dist::Vector{Int}, k::Int)

    # Sanity checks here

    num_outputs = c^k
    A, O = generate_rational_output(c, dist, k)

    # Convert each output dist to 
    B = map(x -> digits(x, base = d) , A)

    # Building tree of prefix codes
    root = TreeNode([], false, Vector{TreeNode}())
    parents = [root]

    for i = k:-1:1
        children_counter = length(parents) * d
        parent_counter = d
        parent_idx = 1
        
        # Collect all leaves in this depth
        for j = 1:num_outputs
            if length(B[j]) >= i
                for m = 1:B[j][i]
                    leaf_node = TreeNode(O[j], true, [])
                    push!(parents[parent_idx].children, leaf_node)
                    children_counter -= 1
                    parent_counter -= 1
                    if parent_counter == 0
                        parent_idx += 1
                        parent_counter = d
                    end
                end
            end
        end

        # Prepare parents for next depth
        next_parents = [TreeNode([], false, Vector{TreeNode}()) for p = 1:children_counter]
        
        # Finish adding nodes to current parents
        for inner_node in next_parents
            push!(parents[parent_idx].children, inner_node)
            parent_counter -= 1
            if parent_counter == 0
                parent_idx += 1
                parent_counter = d
            end
        end

        parents = next_parents
    end

    # Efficiency calculation
    production_entropy = k * sum( map(x -> -x/d * log(2, (x/d)), dist) )
    sum_bases = zeros(Int, k)
    for num in B
        for i = 1:length(num)
            sum_bases[i] += num[i]
        end
    end
    expected_consumption = 0
    for i = 1:k
        expected_consumption += (k-i+1) * sum_bases[i] / d^(k-i+1)
    end
    consumption_entropy = log(2, d) * expected_consumption

    return RationalProtocol(d, c, dist, k, root, root, production_entropy / consumption_entropy)
end

function step_rational_protocol(protocol::RationalProtocol, input::Int)
    next = protocol.state.children[input+1]
    if next.leaf
        protocol.state = protocol.root
        return next.string
    end
    protocol.state = next
    return Vector{Int}()
end

# Generates output strings and the prob. distribution over the output strings
# inv: c, k > 0
function generate_rational_output(c::Int, dist::Vector{Int}, k::Int)
    A = copy(dist) # alpha^k
    O = [[i] for i in 0:c-1] # actual output string

    for i = 2:k
        next_A = Vector{Int}()
        next_O = Vector{Vector{Int}}()
        for j = 1:c
            append!(next_A, A * dist[j])
            q = map(x -> pushfirst!(x, j-1), deepcopy(O))
            append!(next_O, q)
        end
        A = next_A
        O = next_O
    end

    return A, O
end