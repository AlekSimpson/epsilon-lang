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
    if state.curr_tok.type == VAR 
        forward!(state)
        if state.curr_tok.type == IDENTIFIER
            var_name = state.curr_tok
            forward!(state)

            # NOTE: After you finish variable create beginning of error system, Error Report should include the entire lines nodes and the location of the error specficially
            if state.curr_tok.type != TYPE_ASSIGN
                println("ERROR: missing '::' in declaration")
                return # error report
            end

            forward!(state)

            # this basically is checking if state.curr_tok.type is not equal to any of the data types in the DATA_TYPES array
            vector_check = sum(state.curr_tok.type .== DATA_TYPES)
            if vector_check == 0
                # need to check here if identifier is a type
                println("ERROR: expected data type")
                return # error report
            end

            var_name.type = state.curr_tok.type

            forward!(state)
            if state.curr_tok.type == ASSIGN
                forward!(state)
                value = expr(state)
            end
        end

        ret_val = VarDecNode(var_name, value)
        @assert ret_val !== nothing "expr(::ParserState) returning nothing!"
        return VarDecNode(var_name, value) 
    end

    ret_val = arith_expr(state)
    @assert ret_val !== nothing "arith_expr(::ParserState) returning nothing!"
    return ret_val
end

# first layer, checks for add and sub (unless the expression JUST containts mult and div then it also checks for that)
function arith_expr(state::ParserState)
    left = term(state)

    bin_op_return = bin_op(state, arith_expr, [ADD, SUB, MULT, DIV]) 
    if bin_op_return != 0
        return BinOpNode(left, bin_op_return[1], bin_op_return[2])
    end
    return left
end

# second layer checks for mult and div ops
function term(state::ParserState)
    left = power(state)
    
    bin_op_return = bin_op(state, power, [MULT, DIV])
    if bin_op_return != 0 
        return BinOpNode(left, bin_op_return[1], bin_op_return[2])
    end
    return left
end

# third layer checks for exponent operations
function power(state::ParserState)
    left = atom(state)

    bin_op_return = bin_op(state, power, [EXPONENT])
    if bin_op_return != 0
        return BinOpNode(left, bin_op_return[1], bin_op_return[2])
    end
    return left
end

# the last layers checks for the most basic building blocks of an expression which are opening parenthese and numbers (for now)
function atom(state::ParserState)
    if state.curr_tok.type == LPAREN
        forward!(state)
        return expr(state)
    elseif state.curr_tok.type == NUMBER
        return NumberNode(state.curr_tok)
    end
end

# bin_op checks for operator types and then returns the operator and the right side of the expression.
function bin_op(state::ParserState, next_check, operators::Vector{TokenType})
    peek = peek_ahead(state)

    # equality results is a vector of zeros and ones, one represents the true cases for a match and 0 is the false case
    # taking the sum of this list will either return 1 or 0, if 1 then we know a match was found else we know it did not match any operators
    vector_check = sum(peek.type .== operators) == 1

    if vector_check
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
