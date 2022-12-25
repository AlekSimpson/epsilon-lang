include("node.jl")
include("lexer.jl")

mutable struct ParserState
    tokens::Vector{Token}
    idx::Int
    curr_tok::Token
    nodes::Vector{AbstractNode}
end

function forward!(state::ParserState)
    if state.idx != length(state.tokens)
        state.idx += 1
    end
    curr_tok = state.tokens[state.idx]
    return nothing
end

function parse(tokens::Vector{Token})::Vector{AbstractNode}
    state::ParserState = ParserState(tokens, 1, tokens[1], [])
    node = check_atom!(tokens, state)
    state.nodes = [node]

    return state.nodes
end

function check_atom!(with_ops::Vector{Token}, state::ParserState)::AbstractNode
    left = 0
    op = 0
    right = 0
    if state.curr_tok.type == "NUMBER"
        left = state.curr_tok
        forward!(state)
        if CA_tok_with_ops(with_ops, state.curr_tok)
            op = state.curr_tok 
        end
    else
        # push!(state.nodes, NumberNode(state.curr_tok))
        return NumberNode(state.curr_tok)
    end

    forward!(state)
    right = check_atom!(with_ops, state)

    # push!(state.nodes, BinOpNode(left, op, right))
    return BinOpNode(left, op, right)
end

function CA_tok_with_ops(ops::Vector{Token}, token::Token)::Bool
    for op in ops
        if token.type == op.type
            return true
        end
    end
    return false
end
