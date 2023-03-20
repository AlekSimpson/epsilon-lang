include("../Validator.jl")

full_program = LexerTest("Full Program Test", "func main(param::String)::Void\n\tvar name::Int = 45\nend",
                    ["func", "main", "(", "param", "::", "String", ")", "::", "Void", "\n", "var", "name", "::", "Int", "=", "45", "\n", "end"])

variable_test = LexerTest("Variable Test", "var name::String = \"test string\"",
                     ["var", "name", "::", "String", "=", "test string"])

add_test = LexerTest("Add Test", "12 + 32", 
                ["12", "+", "32"])

string_test = LexerTest("String Test", "\"this is a string test\"", 
                   ["this is a string test"])

function_dec = LexerTest("Function Dec", "func main(param::Int)::Void",
                    ["func", "main", "(", "param", "::", "Int", ")", "::", "Void"])

range_test = LexerTest("Range Test", "1:3",
                  ["1", ":", "3"])

equality_test = LexerTest("Equality Test", "==",
                     ["=="])

assignment_test = LexerTest("Assignment Test", "::",
                       ["::"])
array_test = LexerTest("Array Test", "var arr::Array<Int> = [1 2]",
                  ["var", "arr", "::", "Array", "<", "Int", ">", "=", "[", "1", " ", "2", "]"])

lexer_tests = [string_test, variable_test, 
               add_test, function_dec,
               range_test, equality_test,
               assignment_test, full_program, 
               array_test]
