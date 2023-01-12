include("../src/lexer.jl")
include("../src/parser.jl")
include("../src/node.jl")

struct Test
    name::String
    input
    correct
end

struct Result
    result::Bool
    failed_with
    test_name
end


function validate_test(test::Test, test_cat="LEXER")::Result
    categories = Dict("LEXER"=>lexer, "PARSER"=>parse)

    result = categories[test_cat](test.input)
    formatted::Vector{String} = []
    for tok in result
        push!(formatted, tok.value)
    end
    test_res = formatted == test.correct
    return Result(test_res, formatted, test.name)
end


