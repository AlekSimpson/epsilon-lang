include("lexer.jl")
include("parser.jl")

# test = "var name::Array<String> = [\"test\"]"
# test = "var test::Int = 5 + 5" 
# test = "var test::String = \"test\""

test_code_sample = "for i in 1:3\nvar test::Int = i + 5\nend\nvar other::Int = 5"
tokens = lexer(test_code_sample)
ast = parse(tokens)

function display_ast(ast, debug)
    if debug
        display(tokens)
        println("--------------------")
        dump(ast[1])
    else
        println("--------------------")
        println(ast[1])
    end
end

display_ast(ast, false)

