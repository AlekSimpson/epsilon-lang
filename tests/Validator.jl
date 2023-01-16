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


function validate_test(test::LexerTest)::Result
    result = lexer(test.input)
    formatted = []
    for element in result
        push!(formatted, element.value)
    end
    test_res = formatted == test.correct
    return Result(test, test_res, formatted, test.name)
end

function validate_test(test::ParserTest)::Result 
    result = parse(test.input)
    test_res = result[1].value == test.correct.value
    return Result(test, test_res, result[1], test.name)
end


