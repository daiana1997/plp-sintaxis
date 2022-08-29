SET NAME=interpreter
SET DIR=org\unp\plp\interprete
SET PKG=org.unp.plp.interprete
SET JFLEX_HOME=D:\Programas\jflex-1.8.2\jflex-1.8.2


del src\%DIR%\Lexer.java
del src\%DIR%\Parser.java

yacc -J -Jsemantic=Object -Jpackage=%PKG% src\%NAME%.y
move Parser.java src\%DIR%\Parser.java

java -Xmx128m -jar %JFLEX_HOME%\lib\jflex-full-1.8.2.jar -q -d src\%DIR% src\%NAME%.l

if not exist "bin" mkdir bin
javac -d bin src\%DIR%\*.java

java -cp bin %PKG%.Main
