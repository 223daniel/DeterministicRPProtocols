include("rational.jl")

# Testing generate_rational_output
function generate_rational_output_tests()
    println("Testing generate_rational_output for d=3, dist=[5; 7; 12], k=2")
    A_0, O_0 = generate_rational_output(3, [5; 7; 12], 2)
    println("A: ", A_0)
    println("O: ", O_0)
end

# Testing initialization
function initialize_rational_protocol_tests()
    protocol = initialize_rational_protocol(24, 3, [5; 7; 12], 2)
    println("layer 1")
    for node in protocol.root.children
        if node.leaf
            println(node.string)
        end
    end
    println("layer 2")
    for node in protocol.root.children
        if !node.leaf
            for child in node.children
                println(child.string)
            end
        end
    end
end

# Testing step
function step_rational_protocol_tests()
    protocol = initialize_rational_protocol(24, 3, [5; 7; 12], 2)
    println("layer 1")
    for i = 0:20
        println(step_rational_protocol(protocol, i))
    end
    println("layer 2")
    for i = 21:23
        for j = 0:23
            println(step_rational_protocol(protocol, i))
            println(step_rational_protocol(protocol, j))
        end
    end
end
