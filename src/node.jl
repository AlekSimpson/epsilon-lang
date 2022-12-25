include("lexer.jl")
abstract type AbstractNode end

struct BinOpNode  <: AbstractNode
    left::AbstractNode
    op::Token
    right::AbstractNode
end

# Possibly will have to include more in this in the future
struct NumberNode <: AbstractNode
    token::Token
end
