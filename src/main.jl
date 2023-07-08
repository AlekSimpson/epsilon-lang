include("lexer.jl")
include("parser.jl")

# test = "var name::Array<String> = [\"test\"]"
# test = "var test::Int = 5 + 5" 
# test = "var test::String = \"test\""

test_code_sample = "for i inn 1:3\nvar test::Int = i + 5\nend"
tokens = lexer(test_code_sample)
display(tokens)
println("--------------------")

ast = parse(tokens)

function display_ast(ast)
    for node in ast
        println(node)
    end
end

display_ast(ast)
