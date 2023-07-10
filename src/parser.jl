include("node.jl")

mutable struct ParserState
    tokens::Vector{Token}
    idx::Int
    curr_tok::Token
    nodes::Vector{AbstractNode}
    ParserState(toks::Vector{Token}, idx::Int, curr_tok::Token) = new(toks, idx, curr_tok, [])
end

function peek_ahead(state::ParserState)
    if state.idx + 1 > length(state.tokens)
        return state.curr_tok
    end
    return state.tokens[state.idx + 1]
end

# throws error and ends parser execution
function throw_error(state::ParserState, error_tok::Token, error_message::String="", verbose::Bool=true)::ErrorNode
    state.idx = length(state.tokens)
    if verbose
        printstyled("COBOLT ERROR: At line $(error_tok.row), col $(error_tok.col):\n$(error_message)\n"; color=:red, blink=true)
    end
    return ErrorNode(error_tok, error_message)
end

function forward!(state::ParserState, amount=1)
    verbose = false
    temp = state.idx
    if state.idx + amount <= length(state.tokens)
        state.idx += amount 
    end
    if verbose
        println("from idx ($(temp)), to idx ($(state.idx))")
    end
    state.curr_tok = state.tokens[state.idx]
end

function parse(tokens::Vector{Token})::Vector{AbstractNode}
    state::ParserState = ParserState(tokens, 1, tokens[1])
    node = expr(state)
    state.nodes = [node]

    return state.nodes
end

# this function starts the expression check and from the entire grammar tree is checked
function expr(state::ParserState)
    ret_val = parse_var_dec(state)
    if ret_val !== nothing
        return ret_val
    end

    ret_val = arith_expr(state)
    if ret_val == nothing 
        return throw_error(state, state.curr_tok, "arith_expr(::ParserState) returning nothing")
    end
    return ret_val
end

## Specialized Parsing Functions
# Parses array expressions
function parse_array_dec_type(state::ParserState)
    forward!(state)
    if state.curr_tok.type != LCARROT
        return throw_error(state, state.curr_tok, "expected LCARROT in array dec (found $(state.curr_tok.type))")
    end

    forward!(state)
    subtype = state.curr_tok.datatype 
    forward!(state)

    if state.curr_tok.type != RCARROT
        return throw_error(state, state.curr_tok, "expected RCARROT in array dec (found $(state.curr_tok.type))")
    end

    return subtype
end

function parse_var_dec(state::ParserState)
    if state.curr_tok.type == VAR 
        forward!(state)
        if state.curr_tok.type != IDENTIFIER
            return throw_error(state, state.curr_tok, "token type did not match expected IDENTIFIER")
        end
        var_name = state.curr_tok
        forward!(state)

        # NOTE: After you finish variable create beginning of error system, Error Report should include the entire lines nodes and the location of the error specficially
        if state.curr_tok.type != TYPE_ASSIGN
            return throw_error(state, state.curr_tok, "token type did not match expected TYPE_ASSIGN")
        end

        forward!(state)

        # this basically is checking if state.curr_tok.type is not equal to any of the data types in the DATA_TYPES array
        vector_check = sum(state.curr_tok.datatype.type .== DATA_TYPES)
        if vector_check == 0
            return throw_error(state, state.curr_tok, "token type did not match one of the expected data types from DATA_TYPES (found $(state.curr_tok.type))")
        end

        var_name.type = state.curr_tok.type
        var_name.datatype = state.curr_tok.datatype

        if state.curr_tok.datatype.type == ARRAY
            subtype = parse_array_dec_type(state)
            var_name.datatype = Type(var_name.datatype.type, subtype)
        end

        forward!(state)
        if state.curr_tok.type != ASSIGN
            return throw_error(state, state.curr_tok, "Token type did not match expected ASSIGN (found $(state.curr_tok.type))")
        end
        forward!(state)
        value = expr(state)

        ret_val = VarDecNode(var_name, value)
        if ret_val == nothing
            return throw_error(state, state.curr_tok, "expr(::ParserState) returning nothing!")
        elseif VDN_has_type_conflict(ret_val)
            return throw_error(state, state.curr_tok,"Variable had type conflict, ($(var_name) | $(ret_val.assigned_value))" )
        end
        # checks if variable type matches assigned value type
        return VarDecNode(var_name, value) 
    end
end

function array_expr(state::ParserState)
    if state.curr_tok.type != LBRACKET
        return throw_error(state, state.curr_tok, "Expected LBRACKET at beginning of array expression (found $(state.curr_tok.type))")
    end
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
                return throw_error(state, state.curr_tok, "Expected RBRACKET to end array (found $(state.curr_tok.type))")
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

function parse_conditional_statement(state::ParserState)
    tok = state.curr_tok
    conditions::Vector{AbstractNode} = []
    blocks::Vector{Vector{AbstractNode}} = []

    # parses all conditional blocks
    while true
        if state.curr_tok.type == END || state.curr_tok.type == ELSE
            break
        end
        condition, block = parse_if_block(state)

        push!(conditions, condition)
        push!(blocks, block)
    end

    # gets else block if it exists
    if state.curr_tok.type == ELSE
        forward!(state)
        else_block = expr(state)
        return IfNode(tok, conditions, blocks, else_block)
    end

    return IfNode(tok, conditions, blocks)
end

# parses the condition and the block of the conditional
function parse_if_block(state::ParserState)
    # no need to check for IF token, the only way this funciton is called is if the IF token is alreay detected
    if state.curr_tok.type != ELIF && state.curr_tok.type != IF
        return throw_error(state, state.curr_tok, "Expected token ELIF or IF instead found $(state.curr_tok.type)")
    end
    forward!(state)
    condition = expr(state)
    forward!(state)
    block::Vector{AbstractNode} = get_all_statements(state)
    forward!(state)

    ret_val = [condition, block]

    return ret_val
end

# parses while node
function parse_while_node(state::ParserState)
    token = state.curr_tok
    forward!(state)

    condition = expr(state)
    forward!(state)
    block::Vector{AbstractNode} = get_all_statements(state)
    forward!(state)
    return WhileNode(token, condition, block)
end

function parse_for_node(state::ParserState)
    token = state.curr_tok
    forward!(state)

    state.curr_tok.datatype = Type(NUMBER)
    number = AtomNode(Token(VAR, Type(NUMBER), "Int"))
    var_dec = VarDecNode(state.curr_tok, number)
    forward!(state) # forward to the `in` keyword

    if state.curr_tok.type != IN
        return throw_error(state, state.curr_tok, "Expected to find IN token while parsing for node, instead found $(state.curr_tok.type)")
    end
    forward!(state) # forward past the `in` keyword

    range = expr(state)
    var_dec.assigned_value.token.value = range.left.value
    var_dec.assigned_value.token.type = range.left.token.type

    forward!(state)
    block::Vector{AbstractNode} = get_all_statements(state)
    forward!(state)

    return ForNode(token, var_dec, range, block)
end

# gets all lines inside of a code block
function get_all_statements(state::ParserState)
    statements = []
    while state.curr_tok.type == NEWLINE
        forward!(state)
        # checks if code block has ended
        if state.curr_tok.type == END || state.curr_tok.type == ELIF || state.curr_tok.type == ELSE
            break
        end
        statement = expr(state)
        push!(statements, statement)
        forward!(state)
    end

    return statements
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

    bin_op_return = bin_op(state, arith_expr, [ADD, SUB, MULT, DIV, EQUALITY])
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

    bin_op_return = bin_op(state, power, [EXPONENT, RANGE])
    if bin_op_return != 0
        return BinOpNode(left, bin_op_return[1], bin_op_return[2])
    end
    return left
end

# the last layers checks for the most basic building blocks of an expression which are opening parenthese and numbers (for now)
function atom(state::ParserState)
    # atom_types = [STRING, NUMBER, BOOL]
    # vector_check = sum(state.curr_tok.type .== atom_types) == 1
    if state.curr_tok.type == LPAREN
        forward!(state)
        return expr(state)
    elseif state.curr_tok.type == LBRACKET
        return array_expr(state)
    elseif state.curr_tok.type == IF 
        return parse_conditional_statement(state) 
    elseif state.curr_tok.type == STRING 
        return AtomNode(state.curr_tok)
    elseif state.curr_tok.type == NUMBER
        return AtomNode(state.curr_tok)
    elseif state.curr_tok.type == BOOL
        return AtomNode(state.curr_tok)
    elseif state.curr_tok.type == WHILE
        return parse_while_node(state)
    elseif state.curr_tok.type == FOR
        return parse_for_node(state)
    elseif state.curr_tok.type == IDENTIFIER
        return VarAccessNode(state.curr_tok)
    else
        return throw_error(state, state.curr_tok, "")
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
