import java_cup.runtime.Symbol;
import java_cup.runtime.ComplexSymbolFactory;
import java_cup.runtime.ComplexSymbolFactory.Location;
import java.io.InputStream;
import java.io.InputStreamReader;

%%

%cup
%public
%class Lexer
%implements sym
%line
%column

%{
    public Lexer(java.io.Reader in, ComplexSymbolFactory sf){
        this(in);
        symbolFactory = sf;
    }

    ComplexSymbolFactory symbolFactory;
    StringBuffer string = new StringBuffer();

    private Symbol symbol(String name, int sym) {
      return symbolFactory.newSymbol(name, sym, new Location(yyline + 1, yycolumn + 1, yychar), 
                         new Location(yyline + 1, yycolumn + yylength(), yychar + yylength()));
    }

    private Symbol symbol(String name, int sym, Object val) {
      return symbolFactory.newSymbol(name, sym, new Location(yyline + 1, yycolumn + 1, yychar), 
                    new Location(yyline + 1, yycolumn + yylength(), yychar + yylength()), val);
    }

    private void error(String message) {
    System.out.println("Error at line "+(yyline+1)+", column "+(yycolumn+1)+" : "+message);
    }
%}

%eofval{
     return symbolFactory.newSymbol("EOF", EOF, new Location(yyline + 1, yycolumn + 1, yychar), 
                                           new Location(yyline + 1, yycolumn + 1, yychar + 1));
%eofval}

identifier = [a-zA-Z_][a-zA-Z0-9_]*
num = 0 | [1-9][0-9]*
real = [0 | [1-9][0-9]+]+ \. [0 | [1-9][0-9]+]*
ignore = \r | \n | \r\n  | [ \t\f]

%%

/**/
<YYINITIAL> {

    "if"            {return symbol("if", IF); }
    "else"          {return symbol("else", ELSE); }
    "while"         {return symbol("while", WHILE); }

    "{"             {return symbol("begin", BEGIN); }
    "}"             {return symbol("end", END); }
    ";"             {return symbol("semicolon", SEMICOLON); }
    "("             {return symbol("rightpar", LEFTPAR); }
    ")"             {return symbol("leftpar", RIGHTPAR); } 

    "int"           { return symbol("int", INTEGER_TYPE); }
    "char"          { return symbol("char", CHAR_TYPE); }
    "bool"          { return symbol("bool", BOOL_TYPE); }
    "float"         { return symbol("float", FLOAT_TYPE); }

    "+"             { return symbol("plus", PLUS); }
    "-"             { return symbol("minus", MINUS); }
    "*"             { return symbol("times", TIMES); }
    "/"             { return symbol("div", DIVIDE); }
    "="             { return symbol("attrib", EQ); }
    "<="            { return symbol("leq", LEQ); }
    ">="            { return symbol("geq", GEQ); }
    "<"             { return symbol("lt", LT); }
    ">"             { return symbol("gt", GT); }    

    {identifier}    {return symbol("id", IDENTIFIER, yytext()); }

    {num}           { return symbol("intconst", INTEGER, new Integer(yytext())); }  
    {real}          { return symbol("floatconst", FLOAT, 
                               new Float(yytext().substring(0,yylength() - 1))); }  

    {ignore}        {/* IGNORE */}
}
/**/

/*
<YYINITIAL> {

    "if"            {System.out.println("< keyword, if >"); 
                     return symbol("if", IF); }
    "else"          {System.out.println("< keyword, else >"); 
                     return symbol("else", ELSE); }
    "while"         {System.out.println("< keyword, while >"); 
                     return symbol("while", WHILE); }

    "{"             {System.out.println("< separator, { >"); 
                     return symbol("begin", BEGIN); }
    "}"             {System.out.println("< separator, } >"); 
                     return symbol("end", END); }
    ";"             {System.out.println("< separator, ; >"); 
                     return symbol("semicolon", SEMICOLON); }
    "("             {System.out.println("< separator, ( >"); 
                     return symbol("rightpar", LEFTPAR); }
    ")"             {System.out.println("< separator, ) >"); 
                     return symbol("leftpar", RIGHTPAR); } 

    "int"           {System.out.println("< type, int_type >"); 
                     return symbol("int", INTEGER_TYPE); }
    "char"          {System.out.println("< type, char_type >"); 
                     return symbol("char", CHAR_TYPE); }
    "bool"          {System.out.println("< type, bool_type >"); 
                     return symbol("bool", BOOL_TYPE); }
    "float"         {System.out.println("< type, float_type >"); 
                     return symbol("float", FLOAT_TYPE); }

    "+"             {System.out.println("< arith_op, + >"); 
                     return symbol("plus", PLUS); }
    "-"             {System.out.println("< arith_op, - >"); 
                     return symbol("minus", MINUS); }
    "*"             {System.out.println("< arith_op, * >"); 
                     return symbol("times", TIMES); }
    "/"             {System.out.println("< arith_op, / >"); 
                     return symbol("div", DIVIDE); }
    "="             {System.out.println("< attrib, = >"); 
                     return symbol("attrib", EQ); }
    "<="            {System.out.println("< comp_op, <= >"); 
                     return symbol("leq", LEQ); }
    ">="            {System.out.println("< comp_op, >= >"); 
                     return symbol("geq", GEQ); }
    "<"             {System.out.println("< comp_op, < >"); 
                     return symbol("lt", LT); }
    ">"             {System.out.println("< comp_op, > >"); 
                     return symbol("gt", GT); }    

    {identifier}    {System.out.println("< id, "+ yytext() +" >"); 
                     return symbol("id", IDENTIFIER, yytext()); }

    {num}           {System.out.println("< int_const, "+ yytext() +" >"); 
                     return symbol("intconst", INTEGER, new Integer(yytext())); }  
    {real}          {System.out.println("< float_const, "+ yytext() +" >"); 
                     return symbol("floatconst", FLOAT,
                              new Float(yytext().substring(0,yylength() - 1))); }  

    {ignore}        {/* IGNORE */}
}
*/

/* ERROR */
[^]              {  
            error("Illegal character <"+ yytext() +">");
                  }