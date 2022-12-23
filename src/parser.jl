idx = 1
curr_tok = tokens[idx]

function forward()
    idx+=1
    curr_tok = tokens[idx]
end


function parse(tokens::Vector{Token})::Vector{Node}
end

function check_atom(with_ops::Vector{String})
    left = nothing
    op = nothing
    right = nothing

    if curr_tok.type == "NUMBER"
        left = curr_tok
        forward()
        if curr_tok.type != "any of the tokens passed in"
            # throw error
        end

        if curr_tok.type == ":x"
    end
end
