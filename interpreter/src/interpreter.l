// fuente 'jflex' para interprete

package org.unp.plp.interprete;

%%

%class Lexer
%byaccj

%{

  private Parser yyparser;

  /** constructor del analizador sintáctico
  *** acepta como parámetro el lector de caracteres a usar
  **/

  public Lexer(java.io.Reader r, Parser p )
  {
    this(r);
    yyparser = p  ;
  }

  /** devuelve el numero de linea donde está el último caracter leido
  **/

  public int lineaActual()
  {
     return yyline;
  }

%}

%%


"world" { return Parser.WORLD; }
"x" { return Parser.X; }
"[" { return Parser.CORCHETE; }
"]" { return Parser.CORCHETECIERRA; }
"," { return Parser.COMMA; }
";" { return Parser.PUNTOCOMMA; }
"put" { return Parser.PUT; }
"rem" { return Parser.REM; }
"print" { return Parser.PRINT; }
"in" { return Parser.IN; }

"gold" { return Parser.GOLD; }
"pit" { return Parser.PIT; }
"wumpus" { return Parser.WUMPUS; }
"hero" { return Parser.HERO; }

"?" { return Parser.COMODIN; }
":" { return Parser.COLON; }

[0-9]+
   {  yyparser.yylval = new Integer(yytext());
      return Parser.CONSTANT;
   }

\r|\n|\r\n
  { // lleva la cuenta de lineas
    yyline++ ;
    return Parser.NL;
  }

[ \t]+ {  /** accion vacia: se ignoran los espacios y tabuladores **/
       }

[+\-*/\[\],;:><=\?ijx] {
      /** Deja pasar los caracteres únicos como literales **/
      /** No es ninguna expresión regular, sólo los caracteres literales **/
      yyparser.yylval = yytext();
      return yytext().charAt(0);
    }

.      {  /** token desconocido: se produce un mensaje de error **/
          yyparser.yyerror("El lexema '"+yytext()+"' no corresponden a ningún token conocido");
       }
