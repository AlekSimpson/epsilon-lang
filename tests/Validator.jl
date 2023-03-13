include("../src/lexer.jl")
include("../src/parser.jl")
include("../src/node.jl")

abstract type Test end

struct LexerTest <: Test
    name::String
    input
    correct
end

struct ParserTest <: Test
    name::String
    input::Vector{Token}
    correct::AbstractNode
end

struct Result
    test::Test
    result::Bool
    failed_with
    test_name
end

# runs tests for lexer
function validate_test(test::LexerTest)::Result
    error = nothing
    result = try
        lexer(test.input)
    catch e
        error = e
    end
    formatted = []
    for element in result
        push!(formatted, element.value)
    end
    test_res = formatted == test.correct # checks if the result is correct or not
    return Result(test, test_res, formatted, test.name)
end

# runs tests for parser
function validate_test(test::ParserTest)::Result 
    # runs tests and catches error if there is one
    error = nothing
    result = try 
        parse(test.input)
    catch e
        error = e
    end
    # checks to see if result is correct
    test_res = false
    if result isa Vector{AbstractNode}
        test_res = result[1].value == test.correct.value # checks if the result is correct or not
    else
        result = [error]
    end

    return Result(test, test_res, result[1], test.name)
end


