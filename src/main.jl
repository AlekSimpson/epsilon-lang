include("lexer.jl")

test = "var name::Array<Int> = [1 2 3 4 5 6 7 8]"
tokens = lexer(test)
display(tokens)

