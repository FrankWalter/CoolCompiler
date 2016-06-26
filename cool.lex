/*
 *  The scanner definition for COOL.
 */

import java_cup.runtime.Symbol;

class Utility {
  public static void assertion
    (
     boolean expr
     )
      { 
	if (false == expr) {
	  throw (new Error("Error: Assertion failed."));
	}
      }
  
  private static final String errorMsg[] = {
    "Error: Unmatched end-of-comment punctuation.",
    "Error: Unmatched start-of-comment punctuation.",
    "Error: Unclosed string.",
    "Error: Illegal character."
    };
  
  public static final int E_ENDCOMMENT = 0; 
  public static final int E_STARTCOMMENT = 1; 
  public static final int E_UNCLOSEDSTR = 2; 
  public static final int E_UNMATCHED = 3; 

  public static void error
    (
     int code
     )
      {
	System.out.println(errorMsg[code]);
      }
}
%%

%{

/*  Stuff enclosed in %{ %} is copied verbatim to the lexer class
 *  definition, all the extra variables/functions you want to use in the
 *  lexer actions should go here.  Don't remove or modify anything that
 *  was there initially.  */

    // Max size of string constants
    static int MAX_STR_CONST = 1025;

    // For assembling string constants
    StringBuffer string_buf = new StringBuffer();

	private int commentCount = 0;
	private int CurrentSymbolEntryIndex = 0;
    private int curr_lineno = 1;
    int get_curr_lineno() {
	return curr_lineno;
    }

    private AbstractSymbol filename;

    void set_filename(String fname) {
	filename = AbstractTable.stringtable.addString(fname);
    }

    AbstractSymbol curr_filename() {
	return filename;
    }
%}

%init{

/*  Stuff enclosed in %init{ %init} is copied verbatim to the lexer
 *  class constructor, all the extra initialization you want to do should
 *  go here.  Don't remove or modify anything that was there initially. */

    // empty for now
%init}

%eofval{

/*  Stuff enclosed in %eofval{ %eofval} specifies java code that is
 *  executed when end-of-file is reached.  If you use multiple lexical
 *  states and want to do something special if an EOF is encountered in
 *  one of those states, place your code in the switch statement.
 *  Ultimately, you should return the EOF symbol, or your lexer won't
 *  work.  */

    switch(yy_lexical_state) {
    case YYINITIAL:
	/* nothing special to do in the initial state */
	break;
	/* If necessary, add code for other states here, e.g:
	   case COMMENT:
	   ...
	   break;
	*/
    }
    return new Symbol(TokenConstants.EOF);
%eofval}

%class CoolLexer
%cup
%state COMMENT, YYSTRING
LineItem = \r|\n|\r\n
InputItem = [^\n\r]
Alpha = [A-Za-z]
Digit = [0-9]
WhiteSpaceChar = [ \n\f\r\t\v]
SingleLineComment = --{InputItem}*{LineItem}
CommentText = {Alpha} | {Digit} | {WhiteSpaceChar}
ObjectId = [a-z][_a-zA-Z0-9]*
TypeId = [A-Z][_a-zA-Z0-9]*
Integer = [0-9]+
Bool = "false" | "true"
%%
<YYINITIAL> "(*" {
	yybegin(COMMENT);
	commentCount = commentCount + 1;
}
<COMMENT> "(*" {
	commentCount = commentCount + 1;
}
<COMMENT> "*)" {
	commentCount = commentCount - 1;
	Utility.assertion(commentCount >= 0);
	if (commentCount == 0) {
		yybegin(YYINITIAL);
	}
}
<COMMENT> {CommentText} {
	/*skip*/
}
<YYINITIAL> {WhiteSpaceChar} {
	/*skip*/
}
<YYINITIAL> {SingleLineComment} {
	/*skip*/
}

<YYINITIAL>"=>" { 
    /*special symbols*/
    return new Symbol(TokenConstants.DARROW); 
}
<YYINITIAL>"(" {
	return new Symbol(TokenConstants.LPAREN);
}
<YYINITIAL>")" {
	return new Symbol(TokenConstants.RPAREN);
}
<YYINITIAL>"<=" {
	return new Symbol(TokenConstants.LE);
}
<YYINITIAL>"<" {
	return new Symbol(TokenConstants.LT);
}
<YYINITIAL>"=" {
	return new Symbol(TokenConstants.EQ);
}
<YYINITIAL>"{" {
	return new Symbol(TokenConstants.LBRACE);
}
<YYINITIAL>"}" {
	return new Symbol(TokenConstants.RBRACE);
}
<YYINITIAL>"," {
	return new Symbol(TokenConstants.COMMA);
}
<YYINITIAL>":" {
	return new Symbol(TokenConstants.COLON);
}
<YYINITIAL>";" {
	return new Symbol(TokenConstants.SEMI);
}
<YYINITIAL>"<-" {
	return new Symbol(TokenConstants.ASSIGN);
}
<YYINITIAL>"." {
	return new Symbol(TokenConstants.DOT);
}
<YYINITIAL>"@" {
	return new Symbol(TokenConstants.AT);
}
<YYINITIAL>"*" {
	return new Symbol(TokenConstants.MULT);
}
<YYINITIAL>"-" {
	return new Symbol(TokenConstants.MINUS);
}
<YYINITIAL>"/" {
	return new Symbol(TokenConstants.DIV);
}
<YYINITIAL>"+" {
	return new Symbol(TokenConstants.PLUS);
}
<YYINITIAL>"~" {
	/* not determined */
	return new Symbol(TokenConstants.NEG);
}
<YYINITIAL>"class" {
	/*the keywords*/
	return new Symbol(TokenConstants.CLASS);
}
<YYINITIAL>"else" {
	return new Symbol(TokenConstants.ELSE);
}
<YYINITIAL>"fi" {
	return new Symbol(TokenConstants.FI);
}
<YYINITIAL>"if" {
	return new Symbol(TokenConstants.IF);
}
<YYINITIAL>"in" {
	return new Symbol(TokenConstants.IN);
}
<YYINITIAL>"inherits" {
	return new Symbol(TokenConstants.INHERITS);
}
<YYINITIAL>"isvoid" {
	return new Symbol(TokenConstants.ISVOID);
}
<YYINITIAL>"let" {
	return new Symbol(TokenConstants.LET);
}
<YYINITIAL>"loop" {
	return new Symbol(TokenConstants.LOOP);
}
<YYINITIAL>"pool" {
	return new Symbol(TokenConstants.POOL);
}
<YYINITIAL>"then" {
	return new Symbol(TokenConstants.THEN);
}
<YYINITIAL>"while" {
	return new Symbol(TokenConstants.WHILE);
}
<YYINITIAL>"case" {
	return new Symbol(TokenConstants.CASE);
}
<YYINITIAL>"esac" {
	return new Symbol(TokenConstants.ESAC);
}
<YYINITIAL>"new" {
	return new Symbol(TokenConstants.NEW);
}
<YYINITIAL>"of" {
	return new Symbol(TokenConstants.OF); 
}
<YYINITIAL>"not" {
	return new Symbol(TokenConstants.NOT);
}
<YYINITIAL>"\"" {
	yybegin(YYSTRING);
}
<YYSTRING>"\"" {
	yybegin(YYINITIAL);
}
<YYINITIAL>{ObjectId} {
	Symbol result = new Symbol(TokenConstants.OBJECTID, new IdSymbol(yytext(), yytext().length(), CurrentSymbolEntryIndex));
    CurrentSymbolEntryIndex += 1;
	return result;
}
<YYINITIAL>{TypeId} {
	Symbol result = new Symbol(TokenConstants.TYPEID, new IdSymbol(yytext(), yytext().length(), CurrentSymbolEntryIndex));
    CurrentSymbolEntryIndex += 1;
	return result;
}
<YYINITIAL>{Integer} {
	Symbol result = new Symbol(TokenConstants.INT_CONST, new IntSymbol(yytext(), yytext().length(), CurrentSymbolEntryIndex));
    CurrentSymbolEntryIndex += 1;
	return result;
}
<YYINITIAL>{Bool} {
	return new Symbol(TokenConstants.BOOL_CONST, new Boolean(yytext()));
}
.                               { /* This rule should be the very last
                                     in your lexical specification and
                                     will match match everything not
                                     matched by other lexical rules. */
                                  System.err.println("LEXER BUG - UNMATCHED: " + yytext()); }
