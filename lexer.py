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
        self.row = 0
        self.col = 0

class Lexer:
    def __init_(self, input_):
        self.input = input_
        self.curr_index = 0
        self.finished = False
        self.curr_char = self.input[self.curr_index]
        self.tokens = []
        self.row = 0
        self.column = 0
        self.stringOpen = False

    def forward(self):
        if self.curr_index > len(self.input):
            self.finished = True
        else:
            self.curr_index += 1

    def create_tokens(self):
        full_string = ""

        while not self.finished:
            if self.stringOpen:
                full_string += self.curr_char
                continue
            else:
                self.stringOpen = self.curr_char == " "

            if self.curr_char is single_char_symbol:
                tok_type = single_char_symbol[self.curr_char]

            self.tokens.append(Token(tok_type, self.row, self.column))
            self.forward()

