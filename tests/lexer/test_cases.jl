include("../Validator.jl")

full_program = Test("Full Program Test", "func main(param::String)::Void\n\tvar name::Int = 45\nend",
                    ["func", "main", "(", "param", "::", "String", ")", "::", "Void", "var", "name", "::", "Int", "=", "45", "end"])

variable_test = Test("Variable Test", "var name::String = \"test string\"",
                     ["var", "name", "::", "String", "=", "test string"])

add_test = Test("Add Test", "12 + 32", 
                ["12", "+", "32"])

string_test = Test("String Test", "\"this is a string test\"", 
                   ["this is a string test"])

function_dec = Test("Function Dec", "func main(param::Int)::Void",
                    ["func", "main", "(", "param", "::", "Int", ")", "::", "Void"])

range_test = Test("Range Test", "1:3",
                  ["1", ":", "3"])

equality_test = Test("Equality Test", "==",
                     ["=="])

assignment_test = Test("Assignment Test", "::",
                       ["::"])
array_test = Test("Array Test", "var arr::Array<Int> = [1 2]",
                  ["var", "arr", "::", "Array", "<", "Int", ">", "=", "[", "1", " ", "2", "]"])

lexer_tests = [string_test, variable_test, 
               add_test, function_dec,
               range_test, equality_test,
               assignment_test, full_program, 
               array_test]
