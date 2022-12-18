include("lexer.jl")

test = "var name::String = \"test string\""
tokens = lexer(test)
display(tokens)

