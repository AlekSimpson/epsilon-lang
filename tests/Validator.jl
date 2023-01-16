include("../src/lexer.jl")
include("../src/parser.jl")
include("../src/node.jl")

struct Test
    name::String
    input
    correct
end

struct Result
    test::Test
    result::Bool
    failed_with
    test_name
end


function validate_test(test::Test, test_cat="LEXER")::Result
    categories = Dict("LEXER"=>lexer, "PARSER"=>parse)

    result = categories[test_cat](test.input)
    formatted = []
    for element in result
        if test_cat == "LEXER"
            push!(formatted, element.value)
        elseif test_cat == "PARSER"
            push!(formatted, element)
        end
    end
    println("FORMATTED IS $(formatted[1]) \n             $(test.correct[1])")
    test_res = formatted == test.correct
    return Result(test, test_res, formatted, test.name)
end


