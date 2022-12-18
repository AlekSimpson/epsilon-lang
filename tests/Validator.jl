include("../src/lexer.jl")

struct Test
    input::String
    correct::Vector{String}
end

function validate_test(test::Test)::Bool
    result::Vector{Token} = lexer(test.input)
    formatted::Vector{String} = []
    for tok in result
        push!(formatted, tok.value)
    end
    return formatted == test.correct
end


