include("lexer.jl")
include("parser.jl")

test = "var name::Array<String> = [\"test\"]"
# test = "var test::Int = 5 + 5" 
# test = "var test::String = \"test\""
tokens = lexer(test)
println(tokens)
println("-------------------------")

function display(node)
    println(node.left)
    println(node.op)
    println(node.right)
end

ast = parse(tokens)
println(ast[1])
