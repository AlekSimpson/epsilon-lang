include("node.jl")
numbers = "1234567890"
alphanum = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ_"

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
# sel: 1 => to parse numbers
#    : 2 => to parse alphanumeric numbers
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
    char_dict = Dict("[" => LBRACKET, 
                     "]" => RBRACKET, 
                     "#" => COMMENT, 
                     "+" => ADD,
                     "-" => SUB,
                     "*" => MULT,
                     "/" => DIV, 
                     "(" => LPAREN,
                     ")" => RPAREN,
                     "," => COMMA, 
                     "<" => LCARROT,
                     ">" => RCARROT,
                     "=" => ASSIGN,
                     "!" => NOT,
                     ":" => RANGE,
                     "^" => EXPONENT,
                     "\n" => NEWLINE)
    return Token(char_dict[input_char], input_char)
end

# checks if the given input is a keyword or not
function check_for_keyword(input::String, c_idx::Int, items)::Token
    keywords = Dict("var" => VAR, 
                    "func" => FUNC, 
                    "if" => IF, 
                    "while" => WHILE, 
                    "for" => FOR, 
                    "elif" => ELIF, 
                    "end" => END, 
                    "in" => IN,
                    "true" => BOOL, 
                    "false" => BOOL)
    if input in keys(keywords)
        return Token(keywords[input], input)
    end
        
    token_type = IDENTIFIER
    data_type  = check_for_datatype(input, c_idx, items)
    return Token(token_type, data_type, input) 
end

# this function checks if the keyword is also a datatype reference in which case it assigns a data type to it
function check_for_datatype(input::String, c_idx, items)::Type
    type_dict = Dict("Int"    => NUMBER,
                     "Bool"   => BOOL, 
                     "String" => STRING,
                     "Array"  => ARRAY)
    if input in keys(type_dict)
        type = type_dict[input]
        subtype = NilType()
        if type == ARRAY
            # skip '<' so we can immidiately extract the subtype
            c_idx+=2
            word = get_full_item(items, c_idx, alphanum)
            subtype = check_for_datatype(word, c_idx, items)
            c_idx+=2
        end
        return Type(type, subtype)
    end

    return Type(NONE)
end

# Inputs source code outputs list of tokens
function lexer(input::String)::Array{Token}
    items::Array{String, 1} = split(input, "")
    c_idx::Int = 1
    tokens = Array{Token, 1}()
    push!(items, "EOF")
    scanning_array = false

    while true
        # checks if end of file has been reached
        if items[c_idx] == "EOF" 
            break
        end

        # skips over tabs and newlines
        if items[c_idx] == "\t"
            c_idx+=1
            continue
        end

        # logic for if a space should be added or not
        if items[c_idx] == " "
            if scanning_array
                tok = Token(SPACE, " ")
                push!(tokens, tok)
            end
            c_idx += 1
            continue
        end

        # checks for string opening
        if items[c_idx] == "\""
            string = get_full_string(items, c_idx)
            push!(tokens, Token(STRING, Type(STRING), string))
            c_idx += length(string) + 2 
            continue
        end

        # check for numbers
        if check_for_chars(items[c_idx], numbers)
            number = get_full_item(items, c_idx, numbers)
            datatype = Type(NUMBER)
            push!(tokens, Token(NUMBER, datatype, number))
            c_idx += length(number) 
            continue
        end

        # check for words 
        if check_for_chars(items[c_idx], alphanum)
            word = get_full_item(items, c_idx, alphanum)
            tok = check_for_keyword(word, c_idx, items) # returns keyword tok if it is a keyword, else just returns identifier tok
            push!(tokens, tok) 
            c_idx += length(word)
            continue
        end

        # checks for symbols that are a double like :: or ==
        if items[c_idx] == ":" && items[c_idx + 1] == ":" 
            push!(tokens, Token(TYPE_ASSIGN, "::"))
            c_idx += 2
            continue
        elseif items[c_idx] == "=" && items[c_idx + 1] == "="
            push!(tokens, Token(EQUALITY, "=="))
            c_idx += 2
            continue
        end

        # checks for symbols
        tok = check_symbol(items[c_idx])
        push!(tokens, tok)
        if tok.type == LBRACKET
            scanning_array = true
        elseif tok.type == RBRACKET
            scanning_array = false
        end
        c_idx += 1
    end

    return tokens
end
