// fuente byaccj para una calculadora sencilla


%{
  import java.io.*;
  import java.util.List;
  import java.util.ArrayList;
  import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;
import java.util.Set;
%}


// lista de tokens por orden de prioridad

// nueva línea
%token NL         

// constante
%token CONSTANT   

// constante word solo se tiene que aceptar UNA vez
%token WORLD         

// numero x numero
%token X         

// acciones objeto IN celdas
%token IN
%token PUT
%token REM
%token PRINT

// corchete comma corchetecierra puntocomma
%token CORCHETE
%token CORCHETECIERRA
%token COMMA
%token PUNTOCOMMA

// signo ?
%token COMODIN
// signo :
%token COLON

// objetos
%token GOLD
%token PIT
%token WUMPUS
%token HERO

%%

program
  : world_stament statement_list           // Lista de sentencias
  |                           // Programa vacio
  ;

world_stament
  : WORLD CONSTANT X CONSTANT PUNTOCOMMA NL { world.iniciarMundo((int)$2,(int)$4);}
  ;

statement_list
  : action_statement                // Unica sentencia
  | action_statement statement_list // Sentencia,y lista
  ;

action_statement
 : PUT object IN CORCHETE CONSTANT COMMA CONSTANT CORCHETECIERRA PUNTOCOMMA NL { world.poner((String)$2,(int)$5,(int)$7); }
 | REM object IN CORCHETE CONSTANT COMMA CONSTANT CORCHETECIERRA PUNTOCOMMA NL { world.eliminarPit((int)$5,(int)$7); }
 | PRINT WORLD PUNTOCOMMA NL { world.imprimir(); }  
 | PUT PIT IN una_celda { world.ponerPit((Celda)$4); }
 | PUT PIT IN conjunto_celda { world.ponerPits((Collection<Celda>)$4); }
 ;

una_celda
 : CORCHETE CONSTANT COMMA CONSTANT CORCHETECIERRA PUNTOCOMMA NL { $$ = new Celda((int)$2,(int)$4); }
 ;


conjunto_celda
  : CORCHETE CONSTANT COMMA COMODIN COLON cond_list CORCHETECIERRA PUNTOCOMMA NL {$$ = $6;}
  | CORCHETE COMODIN COMMA CONSTANT COLON cond_list CORCHETECIERRA PUNTOCOMMA NL {$$ = $6;}
  | CORCHETE COMODIN COMMA COMODIN COLON cond_list CORCHETECIERRA PUNTOCOMMA NL  {$$ = $6;}
  ;

//  | cond ',' cond_list {$$ = world.condicion((List<Celda>)$1,(List<Celda>)$3,(a,b) -> true);}

cond_list
  : cond
  | cond COMMA cond_list {$$ = world.condicion((List<Celda>)$1,(List<Celda>)$3,(a,b) -> true);}
  ;


// expr '=''=' expr {$$ = world.condicion(((Matriz)$1).celdas(),((Matriz)$4).celdas(),(a,b) -> a == b);}
 
cond
  : expr '=''=' expr {$$ = world.condicion(((Matriz)$1).celdas(),((Matriz)$4).celdas(),(a,b) -> Math.abs(a-b) < 0.1);}
  | expr '>''=' expr {$$ = world.condicion(((Matriz)$1).celdas(),((Matriz)$4).celdas(),(a,b) -> a >= b);}
  | expr '<''=' expr {$$ = world.condicion(((Matriz)$1).celdas(),((Matriz)$4).celdas(),(a,b) -> a <= b);}
  | expr '>' expr    {$$ = world.condicion(((Matriz)$1).celdas(),((Matriz)$3).celdas(),(a,b) -> a > b);}
  | expr '<' expr    {$$ = world.condicion(((Matriz)$1).celdas(),((Matriz)$3).celdas(),(a,b) -> a < b);}
  ;



// La regla expr es ambigua y no posee una correcta asociatividad y precedencia.
// Modificarla para respetar las convenciones matemáticas

expr
  : op
  | expr '+' termino { $$ = Matriz.operar((Matriz)$1, (Matriz)$3, (a,b) -> a+b); }
  | expr '-' termino { $$ = Matriz.operar((Matriz)$1, (Matriz)$3, (a,b) -> a-b); }
  | termino
  ;

 // | expr '*' termino { $$ = Matriz.operar((Matriz)$1, (Matriz)$3, (a,b) -> a*b); }
 // | expr '/' termino { $$ = Matriz.operar((Matriz)$1, (Matriz)$3, (a,b) -> a/b); }


termino
  : termino '*' factor { $$ = Matriz.operar((Matriz)$1, (Matriz)$3, (a,b) -> a*b); }
  | termino '/' factor { $$ = Matriz.operar((Matriz)$1, (Matriz)$3, (a,b) -> a/b); }
  | factor
  ;

factor
  : expr
  | op  
  ;

op
  : CONSTANT  { $$ = Matriz.constante((int)$1); }
  | 'i'       { $$ = Matriz.i(); }
  | 'j'       { $$ = Matriz.j(); }
  ;


object
 : GOLD { $$= "gold"; }
 | HERO { $$= "hero"; }
 | WUMPUS { $$= "wumpus"; }                
 ;


statement
  : CONSTANT NL {System.out.println("constante: "+ $1); $$ = $1;}
  ;


%%

  /** referencia al analizador léxico
  **/
  private Lexer lexer ;

  private WumpusWorld world;

  /** constructor: crea el Interpreteranalizador léxico (lexer)
  **/
  public Parser(Reader r)
  {
     lexer = new Lexer(r, this);
     world = new WumpusWorld();
  }

  /** esta función se invoca por el analizador cuando necesita el
  *** siguiente token del analizador léxico
  **/
  private int yylex ()
  {
    int yyl_return = -1;

    try
    {
       yylval = new Object();
       yyl_return = lexer.yylex();
    }
    catch (IOException e)
    {
       System.err.println("error de E/S:"+e);
    }

    return yyl_return;
  }

  /** invocada cuando se produce un error
  **/
  public void yyerror (String descripcion, int yystate, int token)
  {
     System.err.println ("Error en línea "+Integer.toString(lexer.lineaActual())+" : "+descripcion);
     System.err.println ("Token leído : "+yyname[token]);
  }

  public void yyerror (String descripcion)
  {
     System.err.println ("Error en línea "+Integer.toString(lexer.lineaActual())+" : "+descripcion);
     //System.err.println ("Token leido : "+yyname[token]);
  }
