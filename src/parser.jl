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

# this function starts the expression check and from the entire grammar tree is checked
function expr(state::ParserState)
    return sum_check(state)
end

# first layer, checks for add and sub (unless the expression JUST containts mult and div then it also checks for that)
function sum_check(state::ParserState)
    left = product(state)

    bin_op_return = bin_op(state, product, ["ADD", "SUB", "MULT", "DIV"]) 
    if bin_op_return != 0
        return BinOpNode(left, bin_op_return[1], bin_op_return[2])
    end
    return left
end

# second layer checks for mult and div ops
function product(state::ParserState)
    left = power(state)
    
    bin_op_return = bin_op(state, power, ["MULT", "DIV"])
    if bin_op_return != 0 
        return BinOpNode(left, bin_op_return[1], bin_op_return[2])
    end
    return left
end

# third layer checks for exponent operations
function power(state::ParserState)
    left = value(state)

    bin_op_return = bin_op(state, power, ["EXPONENT"])
    if bin_op_return != 0
        return BinOpNode(left, bin_op_return[1], bin_op_return[2])
    end
    return left
end

# the last layers checks for the most basic building blocks of an expression which are opening parenthese and numbers (for now)
function value(state::ParserState)
    if state.curr_tok.type == "LPAREN"
        forward!(state)
        return expr(state)
    elseif state.curr_tok.type == "NUMBER"
        return NumberNode(state.curr_tok)
    end
end

# bin_op checks for operator types and then returns the operator and the right side of the expression.
function bin_op(state::ParserState, next_check, operators::Vector{String})
    peek = peek_ahead(state)

    # equality results is a vector of zeros and ones, one represents the true cases for a match and 0 is the false case
    # taking the sum of this list will either return 1 or 0, if 1 then we know a match was found else we know it did not match any operators
    equality_results = sum(peek.type .== operators)

    if equality_results == 1
        forward!(state, 2)
        right = next_check(state)
        return [peek, right]
    end
    return 0
end
#= 
expr    <- sum
sum     <- product ((+ || -) product)? 
product <- power ((* || /) power))?
power   <- value (^ power)?
value   <- num || '(' expr ')'
=#
