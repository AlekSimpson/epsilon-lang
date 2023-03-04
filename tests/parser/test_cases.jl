include("../Validator.jl")
include("../../src/node.jl")

add_op_correct = BinOpNode(NumberNode(Token(NUMBER, "1")), 
                           Token(ADD, "+"), 
                           NumberNode(Token(NUMBER, "2")))
add_op = ParserTest("Addition Operator", 
              [Token(NUMBER, "1"),
               Token(ADD, "+"), 
               Token(NUMBER, "2")],
              add_op_correct)

sub_op_correct = BinOpNode(NumberNode(Token(NUMBER, "1")), 
                           Token(SUB, "-"), 
                           NumberNode(Token(NUMBER, "2")))
sub_op = ParserTest("Subtraction Operator", 
              [Token(NUMBER, "1"),
               Token(SUB, "-"), 
               Token(NUMBER, "2")],
              sub_op_correct)

mult_op_correct = BinOpNode(NumberNode(Token(NUMBER, "1")), 
                           Token(MULT, "*"), 
                           NumberNode(Token(NUMBER, "2")))
mult_op = ParserTest("Multiplication Operator", 
               [Token(NUMBER, "1"),
                Token(MULT, "*"), 
                Token(NUMBER, "2")],
               mult_op_correct)

div_op_correct = BinOpNode(NumberNode(Token(NUMBER, "1")), 
                           Token(DIV, "/"), 
                           NumberNode(Token(NUMBER, "2")))
div_op = ParserTest("Division Operator", 
              [Token(NUMBER, "1"),
               Token(DIV, "/"), 
               Token(NUMBER, "2")],
              div_op_correct)

TDO_correct = BinOpNode(NumberNode(Token(NUMBER, "1")), 
                         Token(ADD, "+"), 
                         BinOpNode(NumberNode(Token(NUMBER, "2")), 
                                   Token(MULT, "*"), 
                                   NumberNode(Token(NUMBER, "4"))))

two_diff_ops = ParserTest("Two Different Operators", 
                    [Token(NUMBER, "1"), 
                     Token(ADD, "+"), 
                     Token(NUMBER, "2"),
                     Token(MULT, "*"),
                     Token(NUMBER, "4")],
                    TDO_correct) 

exp_op_correct = BinOpNode(NumberNode(Token(NUMBER, "1")), Token(EXPONENT, "^"), NumberNode(Token(NUMBER, "2")))

exp_op = ParserTest("Exponent Operator",
              [Token(NUMBER, "1"),
               Token(EXPONENT, "^"),
               Token(NUMBER, "2")],
              exp_op_correct)

var_dec_correct = VarDecNode(Token(NUMBER, "test"), NumberNode(Token(NUMBER, "5")))

var_dec = ParserTest("Variable Declaration",
                        [Token(VAR, "var"), 
                         Token(IDENTIFIER, "test"), 
                         Token(TYPE_ASSIGN, "::"), 
                         Token(NUMBER, "Int"), 
                         Token(ASSIGN, "="), 
                         Token(NUMBER, "5")],
                        var_dec_correct)

bool_true_correct = BoolNode(Token(BOOL, "true"))
bool_false_correct = BoolNode(Token(BOOL, "false"))

bool_true = ParserTest("Boolean True Reference",
                       [Token(BOOL, "true")],
                       bool_true_correct)

bool_false = ParserTest("Boolean False Reference",
                       [Token(BOOL, "false")],
                       bool_false_correct)

unary_test = ParserTest("Unary Node",
                        [Token(NOT, "!"), Token(BOOL, "true")],
                        UnaryNode(Token(NOT, "!"), BoolNode(Token(BOOL, "true"))))

parser_tests = [add_op, sub_op, mult_op, div_op, two_diff_ops, exp_op, var_dec, bool_true, bool_false, unary_test]
