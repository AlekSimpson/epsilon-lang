@enum TokenType begin 
    NONE
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
    ARRAY
end

#TODO: Add more of the datatypes lol
DATA_TYPES = [NUMBER, BOOL, STRING, ARRAY]

abstract type AbstractNode end
abstract type Abstract_Type end

struct NilType <: Abstract_Type
    type::TokenType
    NilType() = new(NONE)
end

mutable struct Type <: Abstract_Type
    type::TokenType 
    subtype::Abstract_Type

    Type(t::TokenType) = new(t, NilType())
    Type(t::TokenType, st::Abstract_Type) = new(t, st)
end

mutable struct Token
    type::TokenType
    datatype::Type
    value::String
    row::Int
    col::Int

    Token(type::TokenType, value::String) = new(type, Type(NONE), value, 0, 0)
    Token(type::TokenType, dt::Type, value::String) = new(type, dt, value, 0, 0)
end

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

    VarDecNode(token::Token, assigned_value::AbstractNode) = new(token, assigned_value, "$(token.value)::$(token.datatype.type) = $(assigned_value.value)")
end

VDN_has_type_conflict(node::VarDecNode)::Bool = node.token.datatype.type != node.assigned_value.token.datatype.type

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

struct ArrayNode <: AbstractNode
    token::Token 
    element_type::TokenType
    elements::Array{AbstractNode}
    value::String 

    ArrayNode(token::Token, el_type::TokenType, elements::Array{AbstractNode}) = new(token, el_type, elements, "$(element_type)[$(length(elements))]")
end

struct StringNode <: AbstractNode
    token::Token
    value::String

    StringNode(token::Token) = new(token, token.value)
end
