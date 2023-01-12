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

    function BinOpNode(left::AbstractNode, op::Token, right::AbstractNode)
        left = left
        op = op
        right = right 
        value = "$(left.token.value) $(op.value) $(right.token.value)"
    end
end
        
# Possibly will have to include more in this in the future
struct NumberNode <: AbstractNode
    token::Token
    # raw_value::String
    value::String

    function NumberNode(token::Token)
        value = "$(token.value)"
    end
end
