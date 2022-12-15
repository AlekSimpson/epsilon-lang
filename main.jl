include("lexer.jl")

test = "func main()::String\n\tnum::Int = 34\nend"
tokens = lexer(test)
display(tokens)

