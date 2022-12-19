include("../src/lexer.jl")

struct Test
    name::String
    input::String
    correct::Vector{String}
end

struct Result
    result::Bool
    failed_with::Vector{String}
    test_name::String
end

function validate_test(test::Test)::Result
    result::Vector{Token} = lexer(test.input)
    formatted::Vector{String} = []
    for tok in result
        push!(formatted, tok.value)
    end
    test_res = formatted == test.correct
    return Result(test_res, formatted, test.name)
end


