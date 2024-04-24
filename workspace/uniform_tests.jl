include("uniform.jl")

# Testing invalid protocols
function invalid_protocol_tests()
    println("testing invalid protocols")
    protocol = initialize_uniform_protocol(3, 1000, 2)
    println(protocol === nothing)
end

# Testing generate_output
function generate_output_tests()
    println("generate_output tests")
    print("c = 2, m = 2: ")
    println(generate_output(2, 2))
    print("c = 3, m = 2: ")
    println(generate_output(3, 2))
end

# Testing build_output_array
function build_output_array_tests()
    println("build_output_array tests")
    print("leaves = 3, c = 2: ")
    println(build_output_array(3, 2))
    print("leaves = 4, c = 2: ")
    println(build_output_array(4, 2))
    print("leaves = 5, c = 2: ")
    println(build_output_array(5, 2))
    print("leaves = 6, c = 2: ")
    println(build_output_array(6, 2))
    print("leaves = 9, c = 2: ")
    println(build_output_array(9, 2))
    print("leaves = 9, c = 3: ")
    println(build_output_array(9, 3))
end

# End to end
function protocol_3_2_2_tests()
    println("testing protocol 1: d = 3, c = 2, k = 2")
    protocol_1 = initialize_uniform_protocol(3, 2, 2)
    input_stream_1 = [
        0; 0; 
        0; 1; 
        0; 2; 
        1; 0; 
        1; 1; 
        1; 2; 
        2; 0; 
        2; 1; 
        2; 2;
    ]
    for i in input_stream_1
        print("input ", i, ": ")
        println(step_uniform_protocol(protocol_1, i))
    end
end

function protocol_2_3_4_tests()
    println("testing protocol 2")
    protocol_2 = initialize_uniform_protocol(2, 3, 4)
    input_stream_2 = [
        0; 0; 0; 0;
        0; 0; 0; 1;
        0; 0; 1; 0;
        0; 0; 1; 1;
        0; 1; 0; 0;
        0; 1; 0; 1;
        0; 1; 1; 0;
        0; 1; 1; 1;
        1; 0; 0; 0;
        1; 0; 0; 1;
        1; 0; 1; 0;
        1; 0; 1; 1;
        1; 1; 0; 0;
        1; 1; 0; 1;
        1; 1; 1; 0;
        1; 1; 1; 1;
    ]
    for i in input_stream_2
        print("input ", i, ": ")
        println(step_uniform_protocol(protocol_2, i))
    end
end

function protocol_13_23_2_tests()
    println("testing protocol 3")
    protocol_3 = initialize_uniform_protocol(13, 23, 2)
    input_stream_3 = [
        
    ]
    for i in input_stream_3
        print("input ", i, ": ")
        step = step_uniform_protocol(protocol_3, i)
        if !isempty(step)
            println(step)
        end
    end
end

invalid_protocol_tests()