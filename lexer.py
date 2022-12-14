# epsilon lexer

symbols = ["FUNC",
           "VAR",
           "COLON",
           "IDENTIFIER",
           "EOF",
           "AND",
           "OR",
           "INTEGER",
           "STRING",
           "EQUALITY",
           "IF",
           "ELIF",
           "END",
           "WHILE",
           "FOR",
           "IN",
           "ELSE",
           "LOE",
           "SPACE"]

single_char_symbol = {
        '(': "LPAREN",
        ')': "RPAREN",
        '[': "LBRACKET",
        ']': "RBRACKET",
        '>': "LCARROT",
        '<': "RCARROT",
        '#': "COMMENT",
        '*': "PTRREF",
        '&': "PTRINIT",
        '=': "ASSIGN",
        '\n': "NEWLINE",
        '!': "NOT",
        '+': "ADD",
        ';': "SEMICOLON",
        ',': "COMMA",
        ' ': "SPACE"
    }

class Token:
    def __init__(self, tok_type, row, col):
        self.tok_type = tok_type
        self.row = row
        self.col = col

class Lexer:
    def __init__(self, input_):
        self.items  = input_
        self.ci = 0 # current index
        self.tokens = []
        self.row = 0
        self.column = 0

    def check_letter(self, char):
        chars = list("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXQZ_")
        full_word = ""
        while self.items[self.ci] in chars:
            full_word += self.items[self.ci]
            self.ci += 1
        return full_word

    def create_tokens(self):
        self.curr_item = self.items[self.ci]
        self.items.append("EOF")

        while True:
            if self.curr_item == "EOF":
                break

            if self.check_letter() != "":
                # check keyword
