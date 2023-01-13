include("../Validator.jl")
include("../../src/node.jl")

add_op_correct = BinOpNode(NumberNode(Token("NUMBER", "1")), 
                           Token("ADD", "+"), 
                           NumberNode(Token("NUMBER", "2")))
add_op = Test("Addition Operator", 
              [Token("NUMBER", "1"),
               Token("ADD", "+"), 
               Token("NUMBER", "2")],
              add_op_correct)

sub_op_correct = BinOpNode(NumberNode(Token("NUMBER", "1")), 
                           Token("SUB", "-"), 
                           NumberNode(Token("NUMBER", "2")))
sub_op = Test("Subtraction Operator", 
              [Token("NUMBER", "1"),
               Token("SUB", "-"), 
               Token("NUMBER", "2")],
              sub_op_correct)

mult_op_correct = BinOpNode(NumberNode(Token("NUMBER", "1")), 
                           Token("MULT", "*"), 
                           NumberNode(Token("NUMBER", "2")))
mult_op = Test("Multiplication Operator", 
               [Token("NUMBER", "1"),
                Token("MULT", "*"), 
                Token("NUMBER", "2")],
               mult_op_correct)

div_op_correct = BinOpNode(NumberNode(Token("NUMBER", "1")), 
                           Token("DIV", "/"), 
                           NumberNode(Token("NUMBER", "2")))
div_op = Test("Division Operator", 
              [Token("NUMBER", "1"),
               Token("MULT", "/"), 
               Token("NUMBER", "2")],
              div_op_correct)

TDO_correct = BinOpNode(NumberNode(Token("NUMBER", "1")), 
                         Token("ADD", "+"), 
                         BinOpNode(NumberNode(Token("NUMBER", "2")), 
                                   Token("MULT", "*"), 
                                   NumberNode(Token("NUMBER", "4"))))

two_diff_ops = Test("Two Different Operators", 
                    [Token("NUMBER", "1"), 
                     Token("ADD", "+"), 
                     Token("NUMBER", "2"),
                     Token("MULT", "*"),
                     Token("NUMBER", "4")]
                   , TDO_correct) 


parser_tests = [add_op]#, sub_op, mult_op, div_op, two_diff_ops] 
