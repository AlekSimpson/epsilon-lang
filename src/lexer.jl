include("node.jl")

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

# gets full item from first character
function get_full_item(items::Array{String}, c_idx::Int, chars::String)
    full_item::String = ""
    while check_for_chars(items[c_idx], chars)
        full_item *= items[c_idx]
        c_idx += 1
    end
    return full_item
end

function get_full_string(items::Array{String}, c_idx::Int)
    full_string = ""
    c_idx += 1
    while items[c_idx] != "\""
        full_string *= items[c_idx]
        c_idx += 1 
    end
    return full_string
end

# checks if input is one of those symbols
function check_symbol(input_char::String)::Token
    char_dict = Dict("[" => "LBRACKET", 
                     "]" => "RBRACKET", 
                     "#" => "COMMENT", 
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
                     "!" => "NOT",
                     ":" => "RANGE",
                     "^" => "EXPONENT")
    return Token(char_dict[input_char], input_char)
end

# checks if the given input is a keyword or not
function check_for_keyword(input::String)::Token
    keywords::Vector{String} = ["var", "func", "if", "while", "for", "elif", "end", "in"]
    for keyword in keywords
        if input == keyword
            return Token(uppercase(keyword), input)
        end
    end
    return Token("IDENTIFIER", input)
end

# Inputs source code outputs list of tokens
function lexer(input::String)::Array{Token}
    items::Array{String, 1} = split(input, "")
    c_idx::Int = 1
    tokens = Array{Token, 1}()
    push!(items, "EOF")
    numbers = "1234567890"
    alphanum = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_"
    scanning_array = false

    while true
        # checks if end of file has been reached
        if items[c_idx] == "EOF" 
            break
        end

        # skips over tabs and newlines
        if items[c_idx] == "\n" || items[c_idx] == "\t"
            c_idx+=1
            continue
        end

        # logic for if a space should be added or not
        if items[c_idx] == " "
            if scanning_array
                tok = Token("SPACE", " ")
                push!(tokens, tok)
            end
            c_idx += 1
            continue
        end

        # checks for string opening
        if items[c_idx] == "\""
            string = get_full_string(items, c_idx)
            push!(tokens, Token("STRING", string))
            c_idx += length(string) + 2 
            continue
        end

        # check for numbers
        if check_for_chars(items[c_idx], numbers)
            number = get_full_item(items, c_idx, numbers)
            push!(tokens, Token("NUMBER", number))
            c_idx += length(number) 
            continue
        end

        # check for words 
        if check_for_chars(items[c_idx], alphanum)
            word = get_full_item(items, c_idx, alphanum)
            tok = check_for_keyword(word) # returns keyword tok if it is a keyword, else just returns identifier tok
            push!(tokens, tok) 
            c_idx += length(word)
            continue
        end

        # checks for symbols that are a double like :: or ==
        if items[c_idx] == ":" && items[c_idx + 1] == ":" 
            push!(tokens, Token("TYPE_ASSIGN", "::"))
            c_idx += 2
            continue
        elseif items[c_idx] == "=" && items[c_idx + 1] == "="
            push!(tokens, Token("EQUALITY", "=="))
            c_idx += 2
            continue
        end

        # checks for symbols
        tok = check_symbol(items[c_idx])
        push!(tokens, tok)
        if tok.type == "LBRACKET"
            scanning_array = true
        elseif tok.type == "RBRACKET"
            scanning_array = false
        end
        c_idx += 1
    end

    return tokens
end
