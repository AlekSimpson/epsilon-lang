@enum TokenType begin 
    VAR 
    FUNC 
    IF 
    WHILE 
    FOR 
    ELIF 
    END 
    IN 
    IDENTIFIER 
    SPACE
    STRING
    STRING_TYPE
    NUMBER 
    TYPE_ASSIGN
    EQUALITY
    LBRACKET
    RBRACKET
    LPAREN
    RPAREN
    ADD 
    SUB 
    MULT 
    DIV
    COMMA 
    LCARROT 
    RCARROT 
    ASSIGN 
    NOT 
    RANGE 
    EXPONENT
    COMMENT
    BOOL
end

#TODO: Add more of the datatypes lol
DATA_TYPES = [NUMBER, BOOL]

mutable struct Token
    type::TokenType
    value::String # changed this from Any to String
    row::Int
    col::Int

    Token(type::TokenType, value::String) = new(type, value, 0, 0)
end
    
abstract type AbstractNode end
        
struct BinOpNode <: AbstractNode
    left::AbstractNode
    op::Token
    right::AbstractNode
    token::Token
    value::String

    BinOpNode(left, op, right) = new(left, op, right, left.token, "$(left.value) $(op.value) $(right.value)")
end
        
# Possibly will have to include more in this in the future
struct NumberNode <: AbstractNode
    token::Token
    value::String

    NumberNode(token::Token) = new(token, token.value)
end

struct VarDecNode <: AbstractNode
    token::Token
    assigned_value::AbstractNode
    value::String

    function VarDecNode(token::Token, assigned_value::AbstractNode)
        value = token.value * "::" * string(token.type) * " = " * assigned_value.value
        new(token, assigned_value, value)
    end
end

VDN_has_type_conflict(node::VarDecNode)::Bool = node.token.type != node.assigned_value.token.type

struct UnaryNode <: AbstractNode
    token::Token 
    node::AbstractNode
    value::String

    UnaryNode(token::Token, node::AbstractNode) = new(token, node, "$(token.value)$(node.value)")
end

struct BoolNode <: AbstractNode
    token::Token
    value::String

    BoolNode(token::Token) = new(token, token.value)
end

struct StringNode <: AbstractNode
    token::Token
    value::String

    StringNode(token::Token) = new(token, token.value)
end
