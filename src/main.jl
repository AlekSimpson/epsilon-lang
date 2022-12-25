include("lexer.jl")
include("parser.jl")
include("node.jl")

#test = "var name::Array<Int> = [1 2 3 4 5 6 7 8]"
test = "1 + 1"
tokens = lexer(test)
# display(tokens)

nodes = parse(tokens)
print(nodes)
