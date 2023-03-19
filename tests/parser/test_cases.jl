include("../Validator.jl")
include("../../src/node.jl")

add_op_correct = BinOpNode(AtomNode(Token(NUMBER, "1")), 
                           Token(ADD, "+"), 
                           AtomNode(Token(NUMBER, "2")))
add_op = ParserTest("Addition Operator", 
              [Token(NUMBER, "1"),
               Token(ADD, "+"), 
               Token(NUMBER, "2")],
              add_op_correct)

sub_op_correct = BinOpNode(AtomNode(Token(NUMBER, "1")), 
                           Token(SUB, "-"), 
                           AtomNode(Token(NUMBER, "2")))
sub_op = ParserTest("Subtraction Operator", 
              [Token(NUMBER, "1"),
               Token(SUB, "-"), 
               Token(NUMBER, "2")],
              sub_op_correct)

mult_op_correct = BinOpNode(AtomNode(Token(NUMBER, "1")), 
                           Token(MULT, "*"), 
                           AtomNode(Token(NUMBER, "2")))
mult_op = ParserTest("Multiplication Operator", 
               [Token(NUMBER, "1"),
                Token(MULT, "*"), 
                Token(NUMBER, "2")],
               mult_op_correct)

div_op_correct = BinOpNode(AtomNode(Token(NUMBER, "1")), 
                           Token(DIV, "/"), 
                           AtomNode(Token(NUMBER, "2")))
div_op = ParserTest("Division Operator", 
              [Token(NUMBER, "1"),
               Token(DIV, "/"), 
               Token(NUMBER, "2")],
              div_op_correct)

TDO_correct = BinOpNode(AtomNode(Token(NUMBER, Type(NUMBER), "1")), 
                         Token(ADD, "+"), 
                         BinOpNode(AtomNode(Token(NUMBER, Type(NUMBER), "2")), 
                                   Token(MULT, "*"), 
                                   AtomNode(Token(NUMBER, Type(NUMBER), "4"))))

two_diff_ops = ParserTest("Two Different Operators", 
                         [Token(NUMBER, Type(NUMBER), "1"), 
                          Token(ADD, "+"), 
                          Token(NUMBER, Type(NUMBER), "2"),
                          Token(MULT, "*"),
                          Token(NUMBER, Type(NUMBER), "4")],
                          TDO_correct) 

exp_op_correct = BinOpNode(AtomNode(Token(NUMBER, Type(NUMBER), "1")), Token(EXPONENT, "^"), AtomNode(Token(NUMBER, Type(NUMBER), "2")))

exp_op = ParserTest("Exponent Operator",
                    [Token(NUMBER, Type(NUMBER), "1"),
                     Token(EXPONENT, "^"),
                     Token(NUMBER, Type(NUMBER), "2")],
                     exp_op_correct)

var_dec_correct = VarDecNode(Token(NUMBER, Type(NUMBER), "test"), AtomNode(Token(NUMBER, Type(NUMBER), "5")))

var_dec = ParserTest("Variable Declaration",
                        [Token(VAR, "var"), 
                         Token(IDENTIFIER, Type(NUMBER), "test"), 
                         Token(TYPE_ASSIGN, "::"), 
                         Token(NUMBER, Type(NUMBER), "Int"), 
                         Token(ASSIGN, "="), 
                         Token(NUMBER, Type(NUMBER), "5")],
                        var_dec_correct)

bool_true_correct = AtomNode(Token(BOOL, Type(BOOL), "true"))
bool_false_correct = AtomNode(Token(BOOL, Type(BOOL), "false"))

bool_true = ParserTest("Boolean True Reference",
                       [Token(BOOL, Type(BOOL), "true")],
                       bool_true_correct)

bool_false = ParserTest("Boolean False Reference",
                        [Token(BOOL, Type(BOOL), "false")],
                        bool_false_correct)

unary_test = ParserTest("Unary Node",
                        [Token(NOT, "!"), Token(BOOL, Type(BOOL), "true")],
                         UnaryNode(Token(NOT, "!"), AtomNode(Token(BOOL, Type(BOOL), "true"))))

string_test = ParserTest("Strings",
                         [Token(VAR, "var"), Token(IDENTIFIER, Type(STRING), "test"), Token(TYPE_ASSIGN, "::"), Token(STRING, Type(STRING), "String"), Token(ASSIGN, "="), Token(STRING, Type(STRING), "test")], 
                         VarDecNode(Token(STRING, Type(STRING), "test"), StringNode(Token(STRING, Type(STRING), "test"))))

test_elements::Vector{AbstractNode} = [StringNode(Token(STRING, Type(STRING, NilType()), "test"))]
array_str_test = ParserTest("Array of Strings Test",
                            [Token(VAR, Type(NONE, NilType()), "var"), Token(IDENTIFIER, Type(NONE, NilType()), "name"), Token(TYPE_ASSIGN, Type(NONE, NilType()), "::"), Token(IDENTIFIER, Type(ARRAY, Type(NONE, NilType())), "Array"), Token(LCARROT, Type(NONE, NilType()), "<"), Token(IDENTIFIER, Type(STRING, NilType()), "String"), Token(RCARROT, Type(NONE, NilType()), ">"), Token(ASSIGN, Type(NONE, NilType()), "="), Token(LBRACKET, Type(NONE, NilType()), "["), Token(STRING, Type(STRING, NilType()), "test"), Token(RBRACKET, Type(NONE, NilType()), "]")],
                            VarDecNode(Token(IDENTIFIER, Type(ARRAY, Type(STRING, NilType())), "name"), ArrayNode(Token(ARRAY, Type(ARRAY, Type(STRING, NilType())), "test"), Type(ARRAY, Type(STRING, NilType())), test_elements)))

test_elements = [AtomNode(Token(NUMBER, Type(NUMBER, NilType()), "1"))]
array_int_test = ParserTest("Array of Ints Test",
                            [Token(VAR, Type(NONE, NilType()), "var"), Token(IDENTIFIER, Type(NONE, NilType()), "name"), Token(TYPE_ASSIGN, Type(NONE, NilType()), "::"), Token(IDENTIFIER, Type(ARRAY, Type(NONE, NilType())), "Array"), Token(LCARROT, Type(NONE, NilType()), "<"), Token(IDENTIFIER, Type(NUMBER, NilType()), "Int"), Token(RCARROT, Type(NONE, NilType()), ">"), Token(ASSIGN, Type(NONE, NilType()), "="), Token(LBRACKET, Type(NONE, NilType()), "["), Token(NUMBER, Type(NUMBER, NilType()), "1"), Token(RBRACKET, Type(NONE, NilType()), "]")],
                            VarDecNode(Token(IDENTIFIER, Type(ARRAY, Type(NUMBER, NilType())), "name"), ArrayNode(Token(ARRAY, Type(ARRAY, Type(NUMBER, NilType())), "test"), Type(ARRAY, Type(NUMBER, NilType())), test_elements)))



parser_tests = [add_op, sub_op, mult_op, div_op, two_diff_ops, exp_op, var_dec, bool_true, bool_false, unary_test, string_test, array_str_test, array_int_test]
