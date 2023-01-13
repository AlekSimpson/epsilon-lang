struct Token
    type::String
    value::Any
    row::Int
    col::Int

    function Token(type::String, value::Any)
        new(type, value, 0, 0)
    end 
end
    
abstract type AbstractNode end
        
struct BinOpNode <: AbstractNode
    left::AbstractNode
    op::Token
    right::AbstractNode
    value::String

    BinOpNode(left, op, right) = new(left, op, right, "$(left.value) $(op.value) $(right.value)")
end
        
# Possibly will have to include more in this in the future
struct NumberNode <: AbstractNode
    token::Token
    value::String

    NumberNode(token::Token) = new(token, token.value)
end
