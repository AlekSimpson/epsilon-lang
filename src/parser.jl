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
        @assert state.curr_tok.type == IDENTIFIER "token type did not match expected IDENTIFIER"
        var_name = state.curr_tok
        forward!(state)

        # NOTE: After you finish variable create beginning of error system, Error Report should include the entire lines nodes and the location of the error specficially
        @assert (state.curr_tok.type == TYPE_ASSIGN) "token type did not match expected TYPE_ASSIGN"

        forward!(state)

        # this basically is checking if state.curr_tok.type is not equal to any of the data types in the DATA_TYPES array
        vector_check = sum(state.curr_tok.datatype.type .== DATA_TYPES)
        @assert !(vector_check == 0) "token type did not match one of the expected data types from DATA_TYPES (found $(state.curr_tok.type))"

        var_name.type = state.curr_tok.type
        var_name.datatype = state.curr_tok.datatype

        if state.curr_tok.datatype.type == ARRAY
            subtype = parse_array_dec_type(state)
            var_name.datatype = Type(var_name.datatype.type, subtype)
        end

        forward!(state)
        @assert !(state.curr_tok.type != ASSIGN) "token type did not match expected ASSIGN (found $(state.curr_tok.type))"
        forward!(state)
        value = expr(state)

        ret_val = VarDecNode(var_name, value)
        @assert ret_val !== nothing "expr(::ParserState) returning nothing!"
        # checks if variable type matches assigned value type
        @assert !(VDN_has_type_conflict(ret_val)) "COBOLT ERROR: Variable had type conflict, ($(var_name) | $(ret_val.assigned_value))"
        return VarDecNode(var_name, value) 
    end

    ret_val = arith_expr(state)
    @assert ret_val !== nothing "arith_expr(::ParserState) returning nothing!"
    return ret_val
end

function parse_array_dec_type(state::ParserState)
    forward!(state)
    if state.curr_tok.type != LCARROT
        @assert false "COBOLT ERROR: expected LCARROT in array dec (found $(state.curr_tok.type))"
    end

    forward!(state)

    subtype = state.curr_tok.datatype 

    forward!(state)

    if state.curr_tok.type != RCARROT
        @assert false "COBOLT ERROR: expected RCARROT in array dec (found $(state.curr_tok.type))"
    end

    return subtype
end

## Specialized Parsing Functions
# Parses array expressions
function array_expr(state::ParserState)
    @assert state.curr_tok.type == LBRACKET "expected LBRACKET at beginning of array expression (found $(state.curr_tok.type))"
    elements::Vector{AbstractNode} = []

    forward!(state)

    if state.curr_tok.type == RBRACKET
        forward!()
    else
        while true
            element = expr(state)
            push!(elements, element) 
            forward!(state)
            if state.curr_tok.type != SPACE && state.curr_tok.type == RBRACKET
                break 
            elseif state.curr_tok.type != SPACE 
                @assert false "COBOLT EERROR: Expected RBRACKET to end array (found $(state.curr_tok.type))"
            end
        end
    end

    first_el = nothing
    if length(elements) != 0
        first_el = elements[1] 
    end
    # create token for array so that it correctly reflects the type
    dt = Type(ARRAY, Type(first_el.token.datatype.type))
    arr_tok = Token(ARRAY, dt, first_el.token.value)
    return ArrayNode(arr_tok, dt, elements)
end

## General Parsing Functions Start Here
# first layer, checks for add and sub (unless the expression JUST containts mult and div then it also checks for that)
function arith_expr(state::ParserState)
    if state.curr_tok.type == NOT
        not_tok = state.curr_tok
        forward!(state)
        negated = arith_expr(state)
        return UnaryNode(not_tok, negated)
    end

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
    elseif state.curr_tok.type == LBRACKET
        return array_expr(state)
    else
        AtomNode(state.curr_tok)
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
