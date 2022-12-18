include("../Validator.jl")

full_program = "func main(param::String)::Void\n\tvar name::Int = 45\nend"

variable_test = Test("var name::String = \"test string\"",
                     ["var", " ", "name", "::", "String", " ", "=", " ", "test string"])

add_test = Test("12 + 32", 
                ["12", " ", "+", " ", "32"])

string_test = Test("\"this is a string test\"", 
                   ["this is a string test"])

function_dec = Test("func main(param::Int)::Void",
                    ["func", " ", "main", "(", "param", "::", "Int", ")", "::", "Void"])

range_test = Test("1:3",
                  ["1", ":", "3"])

equality_test = Test("==",
                     ["=="])

assignment_test = Test("::",
                       ["::"])

tests = [string_test, variable_test, 
         add_test, function_dec,
         range_test, equality_test,
         assignment_test]

results = validate_test.(tests)
println(results)

