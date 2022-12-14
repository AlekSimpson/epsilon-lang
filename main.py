# main for running cli
# epsilon idea is basically just julia + pointers and V1 does not include objects
from lexer import Lexer

lex = Lexer("func main()::Void")
print("Tokens:")
toks = lex.create_tokens()
