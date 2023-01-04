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
end
        
# Possibly will have to include more in this in the future
struct NumberNode <: AbstractNode
    token::Token
end
