import java.io.*;
import java_cup.runtime.ComplexSymbolFactory;
import java_cup.runtime.ScannerBuffer;

parser code {:
    public Parser(Lexer lex, ComplexSymbolFactory sf) {
        super(lex,sf);
    }

    public static void main(String[] args) throws Exception {
      ComplexSymbolFactory csf = new ComplexSymbolFactory();      
      ScannerBuffer lexer = new ScannerBuffer(new Lexer(
                            new BufferedReader(new FileReader(args[0])),csf));    
      System.out.println("============================\nParsing file "+ 
                         args[0] + "\n============================\n");
      Parser p = new Parser(lexer,csf);
      Object o = p.parse().value;
      System.out.println("");

    }
:};

terminal IF, ELSE, WHILE, BEGIN, END, SEMICOLON, LEFTPAR, RIGHTPAR;
terminal INTEGER_TYPE, CHAR_TYPE, BOOL_TYPE, FLOAT_TYPE, EQ, LT, LEQ, GT, GEQ;
terminal PLUS, MINUS, TIMES, DIVIDE, IDENTIFIER, INTEGER, FLOAT;

non terminal program, block, decls, decl, type, stmts, stmt, rel, expr, term, unary, factor;

precedence left ELSE;

program ::= block {: System.out.println("program → block"); :}
    ;
block ::= BEGIN decls stmts END {: System.out.println("block → { decls stmts }"); :}
    ;
decls ::= decls decl {: System.out.println("decls → decls decl"); :}
    | {: System.out.println("decls → e"); :} /* EMPTY RULE */
    ;
decl ::= type IDENTIFIER:ide SEMICOLON {: System.out.println("decl → type id("+ ide +")"); :}
    ;
type ::= INTEGER_TYPE {: System.out.println("type → int"); :}
    | CHAR_TYPE {: System.out.println("type → char"); :}
    | BOOL_TYPE {: System.out.println("type → bool"); :}
    | FLOAT_TYPE {: System.out.println("type → float"); :}
    ;
stmts ::= stmts stmt {: System.out.println("stmts → stmts stmt"); :}
    | {: System.out.println("stmts → e"); :} /* EMPTY RULE */
    ;
stmt ::= IDENTIFIER:ide EQ expr SEMICOLON 
      {: System.out.println("stmt → id("+ ide +") = expr"); :}
    | IF LEFTPAR rel RIGHTPAR stmt 
      {: System.out.println("stmt → if ( rel ) stmt"); :}
    | IF LEFTPAR rel RIGHTPAR stmt ELSE stmt 
      {: System.out.println("stmt → if ( rel ) stmt else stmt"); :}
    | WHILE LEFTPAR rel RIGHTPAR stmt 
      {: System.out.println("stmt → while ( rel ) stmt"); :}
    | block {: System.out.println("stmt → block"); :}
    ;
rel ::= expr LT expr {: System.out.println("rel → expr < expr"); :}
    | expr LEQ expr {: System.out.println("rel → expr <= expr"); :}
    | expr GEQ expr {: System.out.println("rel → expr >= expr"); :}
    | expr GT expr {: System.out.println("rel → expr > expr"); :}
    | expr  {: System.out.println("rel → expr"); :}
    ;
expr ::= expr PLUS term {: System.out.println("expr → expr + term"); :}
    | expr MINUS term {: System.out.println("expr → expr - term"); :}
    | term {: System.out.println("expr → term"); :}
    ;
term ::= term TIMES unary {: System.out.println("term → term * unary"); :}
    | term DIVIDE unary {: System.out.println("term → term / unary"); :}
    | unary {: System.out.println("term → unary"); :}
    ;
unary ::= MINUS unary {: System.out.println("unary → - unary"); :}
    | factor {: System.out.println("unary → factor"); :}
    ;
factor ::= INTEGER:inte {: System.out.println("factor → num("+ inte +")"); :}
    | FLOAT:flt {: System.out.println("factor → real("+ flt +")"); :}
    ;