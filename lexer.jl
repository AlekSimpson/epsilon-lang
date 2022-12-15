struct Token
    tok_type::String
    value::Any
    row::Int
    col::Int
end

# Token Initializer
function Tok(tok_type::String, value::Any)::Token
    return Token(tok_type, value, 0, 0)
end

# checks if input is a letter or _
function check_for_chars(input_char::String, chars::String)::Bool
    chars = split(chars, "")
    for char in chars
        if input_char == char
            return true
        end
    end
    return false
end

function get_word(items::Array{String}, c_idx::Int)
    full_word::String = ""
    while check_for_chars(items[c_idx], "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_")
        full_word *= items[c_idx]
        c_idx += 1
    end
    return full_word
end

function check_symbol(input_char::String)::Token
    char_dict = Dict("[" => "LBRACKET", 
                     "]" => "RBRACKET", 
                     "#" => "COMMENT", 
                     " " => "SPACE", 
                     "+" => "ADD", 
                     "-" => "SUB",
                     "*" => "MULT",
                     "/" => "DIV", 
                     "(" => "LPAREN",
                     ")" => "RPAREN",
                     "," => "COMMA", 
                     "<" => "LCARROT",
                     ">" => "RCARROT",
                     "=" => "ASSIGN",
                     "!" => "NOT")
    return Tok(char_dict[input_char], input_char)
end

function get_number(items::Array{String}, c_idx::Int)
    full_num::String = ""
    while check_for_chars(items[c_idx], "1234567890")
        full_num *= items[c_idx]
        c_idx+=1
    end
    return full_num
end

# Inputs source code outputs list of tokens
function lexer(input::String)::Array{Token}
    items::Array{String, 1} = split(input, "")
    c_idx::Int = 1
    tokens = Array{Token, 1}()
    push!(items, "EOF")

    while true
        if items[c_idx] == "EOF" 
            break
        end

        if items[c_idx] == "\n" || items[c_idx] == "\t"
            c_idx+=1
            continue
        end

        if check_for_chars(items[c_idx], "1234567890")
            number = get_number(items, c_idx)
            push!(tokens, Tok("NUMBER", parse(Int, number)))
            c_idx += length(number) 
            continue
        end

        if check_for_chars(items[c_idx], "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_") # check for word
            word = get_word(items, c_idx)
            push!(tokens, Tok("IDENTIFIER", word))
            c_idx += length(word)
            continue
        end

        if items[c_idx] == ":" && items[c_idx + 1] == ":" 
            push!(tokens, Tok("TYPE_ASSIGN", "::"))
            c_idx += 2
            continue
        elseif items[c_idx] == "=" && items[c_idx + 1] == "="
            push!(tokens, Tok("EQUALITY", "=="))
            c_idx += 2
            continue
        end

        tok = check_symbol(items[c_idx])
        push!(tokens, tok)
        c_idx += 1
    end
    return tokens
end
