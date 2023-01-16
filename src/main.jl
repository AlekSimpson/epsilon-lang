include("lexer.jl")
include("parser.jl")

#test = "var name::Array<Int> = [1 2 3 4 5 6 7 8]"
# test = "1 ^ 2"
test = "var test::Int = 5" 
tokens = lexer(test)
println(tokens)

function display(node)
    println(node.left)
    println(node.op)
    println(node.right)
end

ast = parse(tokens)
println(ast[1])
