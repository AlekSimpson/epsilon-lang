struct Token
    tok_type::String
    row::Int
    col::Int
end

# Token Initializer
function Tok(tok_type::String)::Token
    return Token(tok_type, 0, 0)
end

# checks if input is a letter or _
function check_letter(input_char::String)::Bool
    chars = split("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_", "")
    for char in chars
        if input_char == char
            return true
        end
    end
    return false
end

function get_word!(items::Array{String}, c_idx::Int)
    full_word = ""
    while check_letter(items[c_idx])
        full_word += items[c_idx]
        c_idx += 1
    end
    return full_word
end

# Inputs source code outputs list of tokens
function lexer(input::String)::Array{Token}
    items = split(input, "")
    c_idx::Int = 1
    tokens = Array{Token, 1}()
    push!(items, "EOF")

    #while true
    #    if items[c_idx] == "EOF" 
    #        break
    #    end

    #    if check_letter(items[c_idx]) 
    #        print(c_idx)
    #        word = get_word!(items, c_idx)
    #        print(c_idx)
    #        break
    #    end
    #end
end
