include("node.jl")

mutable struct ParserState
    tokens::Vector{Token}
    idx::Int
    curr_tok::Token
    nodes::Vector{AbstractNode}
end

function peek_ahead(state::ParserState)
    if state.idx + 1 > length(state.tokens)
        return state.curr_tok
    end
    return state.tokens[state.idx + 1]
end

function forward!(state::ParserState, amount=1)
    if state.idx + amount <= length(state.tokens)
        state.idx += amount 
    end
    state.curr_tok = state.tokens[state.idx]
end

function parse(tokens::Vector{Token})::Vector{AbstractNode}
    state::ParserState = ParserState(tokens, 1, tokens[1], [])
    node = expr(state)
    state.nodes = [node]

    return state.nodes
end

function expr(state::ParserState)
    return sum(state)
end

function sum(state::ParserState)
    left = product(state)
    if peek_ahead(state).type == "ADD" || peek_ahead(state).type == "SUB"
        forward!(state)
        op = state.curr_tok
        forward!(state)
        right = product(state)
        return BinOpNode(left, op, right) 
    elseif peek_ahead(state).type =="MULT" || peek_ahead(state).type == "DIV"
        forward!(state)
        op = state.curr_tok
        forward!(state)
        right = product(state)
        return BinOpNode(left, op, right)
    end

    return left
end

function product(state::ParserState)
    left = value(state)
    if peek_ahead(state).type == "MULT" || peek_ahead(state).type == "DIV"
        forward!(state)
        op = state.curr_tok 
        forward!(state)
        right = value(state)
        return BinOpNode(left, op, right)
    end
    return left
end

#function power(state::ParserState)
#    left = value(state)
#    if peek_ahead(state).type == "EXPONENT"
#        op = peek_ahead(state)
#        forward!(state, 2)
#        right = power(state)
#        return BinOpNode(left, op, right)
#    end
#    return left
#end

function value(state::ParserState)
    if state.curr_tok.type == "LPAREN"
        forward!(state)
        return expr(state)
    elseif state.curr_tok.type == "NUMBER"
        return NumberNode(state.curr_tok)
    end
end

#= 
expr    <- sum
sum     <- product ((+ || -) product)? 
product <- power ((* || /) power))?
power   <- value (^ power)?
value   <- num || '(' expr ')'
=#
