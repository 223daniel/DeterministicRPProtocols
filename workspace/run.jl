include("uniform.jl")
include("rational.jl")

function uniform()
    ## CHANGE VALUES HERE ##
    d = 13
    c = 23
    k = 4
    ########################

    protocol = initialize_uniform_protocol(d, c, k)
    println("efficiency: ", protocol.efficiency)

    input_frequency = zeros(Int, d)
    output_frequency = zeros(Int, c)
    for i = 1:10000
        input = rand(0:d-1)
        input_frequency[input+1] += 1
        output = step_uniform_protocol(protocol, input)
        for num in output
            output_frequency[num+1] += 1
        end
    end

    println("input frequency: ", input_frequency)
    println("output frequency: ", output_frequency)
end

function rational()
    ## CHANGE VALUES HERE ##
    d = 24
    c = 3
    dist = [5, 7, 12]
    k = 2
    ########################

    protocol = initialize_rational_protocol(d, c, dist, k)
    println("efficiency: ", protocol.efficiency)

    input_frequency = zeros(Int, d)
    output_frequency = zeros(Int, c)
    for i = 1:10000
        input = rand(0:d-1)
        input_frequency[input+1] += 1
        output = step_rational_protocol(protocol, input)
        for num in output
            output_frequency[num+1] += 1
        end
    end

    println("input frequency: ", map(x -> x / sum(input_frequency), input_frequency))
    println("output frequency: ", map(x -> x / sum(output_frequency), output_frequency))
end

# Here, you can call either uniform() or rational() to run the program

rational()