<<<<<<< HEAD
### Paradigmas y Lenguajes de Programación - UNPSJB-PM

# Interprete Simple
El objetivo de este trabajo es construir un interprete de un lenguaje simple mediante la utilización de **Java** como lenguaje base y las herramientas **Lex** y **Yacc** correspondientes.

La finalidad del lenguaje a interpretar generar series de números a partir de sentencias que indican las reglas para la construcción de estas series.

## Preliminar
Se debe contar con un entorno para el desarrollo de programas en Java y descargar e instalar las siguientes implementaciones de Lex y Yacc:
* Implementación de Lex para Java [JFlex](http://jflex.de/)

* Implementación de Yacc para Java [Byacc/J](http://byaccj.sourceforge.net/)

> Arch: `sudo paru -S byacc byaccj jflex`

> Ubuntu: `sudo apt-get install byacc byacc-j jflex`

Luego es necesario realizar un fork del repositorio y trabajar sobre los códigos iniciales aquí facilitados.

### Verificación del ambiente
Antes de comenzar el desarrollo es necesario verificar el correcto funcionamiento del ambiente.

#### Linux
> 1. Abrir una terminal en el directorio `interpreter`.

> 1. Ejecutar el comando `make`. Esto generará y compilará los archivos `src/org/unp/plp/interprete/Lexer.java`, `src/org/unp/plp/interprete/Parser.java` y los 4 archivos `.class` en el directorio `bin`

> 1. Ejecutar el interprete usando el comando `make run`. Este se ejecutará en modo interactivo recibiendo comandos, de momento sólo reconoce números enteros.

#### Windows
> 1. Ejecutar `cmd` y dirigirse al directorio `interpreter`.

> 1. Editar `make.bat` indicando la ruta donde fue descargado `JFlex` modificando la variable `JFLEX_HOME`.

> 1. Ejecutar el script `make.bat`. Esto generará y compilará los archivos `src/org/unp/plp/interprete/Lexer.java`, `src/org/unp/plp/interprete/Parser.java` y los 4 archivos `.class` en el directorio `bin`. Finalmente ejecutará el interprete.

> 1. Al ejecutar el interprete usando el comando `make.bat` este se ejecutará en modo interactivo recibiendo comandos, de momento sólo reconoce números enteros.

# Introducción

> El **Mundo Wumpus** es una caverna conformada por cámaras conectadas por pasillos. Escondido en alguna parte de la caverna se encuentra el terrible **Wumpus**, una bestia que se come a cualquiera que se atreva a entrar a su cámara. El Wumpus puede ser eliminado con un disparo, pero el héroe dispuesto a enfrentarlo solo cuenta con una flecha. Algunas cámaras contienen pozos sin fondo que atraparı́an a cualquiera que vague por estas cámaras. La única caracterı́stica atenuante de este sombrı́o ambiente es la posibilidad de encontrar un montı́culo de oro.

La compañı́a desarrolladora de videojuegos *Text Adventures Games Inc.* nos ha contactado para solicitarnos la creación de un prototipo de lenguaje de programación y la implementación de su interprete para facilitarles el desarrollo de su nueva serie de juegos *Mundo Wumpus*.

A continuación se presentan los requerimientos y especificaciones que necesitan satisfacer.

# Requerimientos y Especificaciones

La programación del Mundo Wumpus puede pensarse en dos etapas, la de definición del mundo y la de juego. La definición del mundo debe realizarse una única vez, pero sobre esa misma definición es necesario poder jugar múltiples veces.

## Etapa de definición

Mundo Wumpus se juega sobre un entorno representado por una grilla donde cada casilla representa una cámara de la caverna.

![Grilla Wumpus World]()

Lo primero que se debe realizar en la etapa de definición es determinar el tamaño del mundo, con la sentencia:

    world 4x5;

*Indicando que el mundo está formado por 4 filas y 5 columnas.*

Una vez definido el tamaño del mundo es necesario poblarlo con los elementos que lo conforman (pozos, oro y Wumpus), por lo que es necesario, en principio, una sentencia que permita hacer referencia a una celda particular. La notación para realizar esto es de la forma:

    [2,3]

*Hace referencia a la celda en la fila 2 y columna 3.*

Para la definición del mundo se requieren dos sentencias para poner y sacar elementos, definidas como put y rem
respectivamente, para ser utilizadas como sigue:

* `put gold in [5,5];` Pone oro en la casilla 5,5
* `rem pit in [3,4];` Remueve el pozo de la casilla 3,4
* `put wumpus in [6,1];` Pone al wumpus en la casilla 6,1

Se debe tener en cuenta que sólo está permitido un montı́culo de oro y un Wumpus en el mundo, por lo que la acción de poner debe sobreescribir la posición anterior si se intenta poner más de uno.

Debido a que puede haber muchos pozos en el mundo, y se espera programar algunos mundos muy grandes, es necesario una mecánica que permita poner más de un pozo a la vez, especificando alguna lógica para su emplazamiento, por ejemplo:

* `put pit in [?, ? : i == j];` Pone pozos por la diagonal donde la fila es igual a la columna.
* `rem pit in [2, ? : j = 2N];` Remueve pozos en la fila 2 donde la columna sea par.
* `put pit in [?, ? : i >j, i + j >= 3];` Pone pozos en las casillas cuya fila sea mayor a la columna y, además, la suma de la fila y columna sea mayor o igual a 3.

Cuando aparecen `?` en las filas y/o columnas, siempre se hará referencia a ellas con las variables `i` y `j` respectivamente.

Este método para hacer referencia a conjuntos de casillas debe soportar el conjunto de expresiones del siguiente cuadro.


| Expresión | Notación | Significado | Ejemplos |
|-|-|-|-|
| Aritméticas | +, −, ∗, \ | suma, resta, multiplicación, división entera | i + 3 <br/> j ∗ 2 + 5 <br/> i + j / 4 |
| Relaciones | ==, <, >, <=, >= | igual, menor, mayor, menor o igual, mayor o igual | i > 2 <br/> j <= 7 <br/> i + 3 == j |
| Forma | k=aN+b <br/> k=aN-b | k es de la forma aN+b, donde a y b pueden ser cualquier escalar o estar ausentes. | i = 2N → i = 0, 2, 4, 6, ...<br/> j = 3N − 1 → j = 0, 2, 5, 8, ... |

Cuando se utilizan expresiones, después de `:` todas las expresiones separadas por `,` deben evaluarse como un *AND* lógico.

Estas son las sentencias necesarias para definir el ambiente, pero se debe tener en cuenta que no puede haber conflictos en las casillas, o sea, no puede haber dos elementos diferentes en la misma casilla, por lo que se deja a discreción de la implementación como responde el interprete a instrucciones conflictivas.

Finalmente, con fines de debugging, es necesario implementar una sentencia que permita ver como está formado el mundo.

    print world;

Esta sentencia debe devolver a la salida estándar la información completa del mundo en el siguiente formato:

    world 5x5
    wumpus [3,2]
    gold [5,4]
    pits [2,3][5,1][4,2]

Donde `world` indica el tamaño del mundo, `wumpus` la posición del Wumpus, `gold` la posición del oro y `pits` una lista con las posiciones de los pozos. Como agregado adicional esta información es suficiente para reconstruir el mundo.


## Etapa de juego

Luego de haber definido todo el mundo es posible utilizar el interprete para jugar el juego. La siguiente sentencia es necesaria para indicar que el juego comienza:

    start

Además de establecer que no se podrá modificar más el contenido del mundo, inicializa todas las variables de contexto en el siguiente estado inicial:

    hero [1,1] right
    arrow yes
    wumpus alive
    actions 0
    status playing

Cada vez que se ejecute `start`, sin importar el estado del juego, el contexto debe ser vuelto al estado inicial. Se debe implementar también la sentencia de debug `print status` que muestre la información anterior en ese formato.

El héroe cuenta con la siguiente lista de acciones:

| Acción | Efecto|
|-|-|
| turn left | El héroe gira en sentido anti-horario.
| turn right | El héroe gira en sentido horario.
| walk | El héroe avanza hacia la dirección que está orientado.
| percept | Indica si hay una brisa, un crujido y/o un destello.
| shoot | Dispara la flecha en la dirección que mira el héroe.


Las acciones modifican el estado del juego y generan una salida según el nuevo estado.

La salida de turn `left/right` indican la nueva dirección del héroe, con lo valores posibles `right`, `left`, `up`, `down`.

La acción `walk` puede derivar en varias posibilidades, la misma salida de `percept` si la casilla está vacı́a, `eaten` si el Wumpus estaba en la casilla destino, fallen si habı́a un pozo en la casilla destino, `rich` si en la casilla estaba el oro o `bump` si en la dirección que quiso ir no habı́a casilla sino una pared.

La salida de `percept` puede dar varios datos separados por coma: `strench` si el Wumpus está en una de las casillas adyacentes, `breeze` si hay un pozo en la casilla adyacente o `glitter` si el oro está en la dirección que el héroe está mirando.

Por último, la acción `shoot` retorna `click` si la flecha falla o `scream` si la flecha le da al Wumpus.

Finalmente si el héroe muere no serı́a posible seguir jugando, pero se podrı́a retroceder mediante la siguiente sentencia:
    
    status - 3

Esto permite retroceder el estado tres pasos para volver a intentar. Se puede indicar cualquier número de pasos que retroceder.

Para ganar el juego el héroe debe tomar el oro y volver a la casilla inicial. Los estados posibles del juego son playing, win o lose.
#   P L P l a b o r a t o r i o  
 
=======
### Paradigmas y Lenguajes de Programación - UNPSJB-PM

# Interprete Simple
El objetivo de este trabajo es construir un interprete de un lenguaje simple mediante la utilización de **Java** como lenguaje base y las herramientas **Lex** y **Yacc** correspondientes.

La finalidad del lenguaje a interpretar generar series de números a partir de sentencias que indican las reglas para la construcción de estas series.

## Preliminar
Se debe contar con un entorno para el desarrollo de programas en Java y descargar e instalar las siguientes implementaciones de Lex y Yacc:
* Implementación de Lex para Java [JFlex](http://jflex.de/)

* Implementación de Yacc para Java [Byacc/J](http://byaccj.sourceforge.net/)

> Arch: `sudo paru -S byacc byaccj jflex`

> Ubuntu: `sudo apt-get install byacc byacc-j jflex`

Luego es necesario realizar un fork del repositorio y trabajar sobre los códigos iniciales aquí facilitados.

### Verificación del ambiente
Antes de comenzar el desarrollo es necesario verificar el correcto funcionamiento del ambiente.

#### Linux
> 1. Abrir una terminal en el directorio `interpreter`.

> 1. Ejecutar el comando `make`. Esto generará y compilará los archivos `src/org/unp/plp/interprete/Lexer.java`, `src/org/unp/plp/interprete/Parser.java` y los 4 archivos `.class` en el directorio `bin`

> 1. Ejecutar el interprete usando el comando `make run`. Este se ejecutará en modo interactivo recibiendo comandos, de momento sólo reconoce números enteros.

#### Windows
> 1. Ejecutar `cmd` y dirigirse al directorio `interpreter`.

> 1. Editar `make.bat` indicando la ruta donde fue descargado `JFlex` modificando la variable `JFLEX_HOME`.

> 1. Ejecutar el script `make.bat`. Esto generará y compilará los archivos `src/org/unp/plp/interprete/Lexer.java`, `src/org/unp/plp/interprete/Parser.java` y los 4 archivos `.class` en el directorio `bin`. Finalmente ejecutará el interprete.

> 1. Al ejecutar el interprete usando el comando `make.bat` este se ejecutará en modo interactivo recibiendo comandos, de momento sólo reconoce números enteros.

# Introducción

> El **Mundo Wumpus** es una caverna conformada por cámaras conectadas por pasillos. Escondido en alguna parte de la caverna se encuentra el terrible **Wumpus**, una bestia que se come a cualquiera que se atreva a entrar a su cámara. El Wumpus puede ser eliminado con un disparo, pero el héroe dispuesto a enfrentarlo solo cuenta con una flecha. Algunas cámaras contienen pozos sin fondo que atraparı́an a cualquiera que vague por estas cámaras. La única caracterı́stica atenuante de este sombrı́o ambiente es la posibilidad de encontrar un montı́culo de oro.

La compañı́a desarrolladora de videojuegos *Text Adventures Games Inc.* nos ha contactado para solicitarnos la creación de un prototipo de lenguaje de programación y la implementación de su interprete para facilitarles el desarrollo de su nueva serie de juegos *Mundo Wumpus*.

A continuación se presentan los requerimientos y especificaciones que necesitan satisfacer.

# Requerimientos y Especificaciones

La programación del Mundo Wumpus puede pensarse en dos etapas, la de definición del mundo y la de juego. La definición del mundo debe realizarse una única vez, pero sobre esa misma definición es necesario poder jugar múltiples veces.

## Etapa de definición

Mundo Wumpus se juega sobre un entorno representado por una grilla donde cada casilla representa una cámara de la caverna.

![Grilla Wumpus World](wumpus-world.png)

Lo primero que se debe realizar en la etapa de definición es determinar el tamaño del mundo, con la sentencia:

    world 4x5;

*Indicando que el mundo está formado por 4 filas y 5 columnas.*

Una vez definido el tamaño del mundo es necesario poblarlo con los elementos que lo conforman (pozos, oro y Wumpus), por lo que es necesario, en principio, una sentencia que permita hacer referencia a una celda particular. La notación para realizar esto es de la forma:

    [2,3]

*Hace referencia a la celda en la fila 2 y columna 3.*

Para la definición del mundo se requieren dos sentencias para poner y sacar elementos, definidas como put y rem
respectivamente, para ser utilizadas como sigue:

* `put gold in [5,5];` Pone oro en la casilla 5,5
* `rem pit in [3,4];` Remueve el pozo de la casilla 3,4
* `put wumpus in [6,1];` Pone al wumpus en la casilla 6,1
* `put hero in [4,2];` Pone al heroe en la casilla 4,2

Se debe tener en cuenta que sólo está permitido un montı́culo de oro y un Wumpus en el mundo, por lo que la acción de poner debe sobreescribir la posición anterior si se intenta poner más de uno.

Debido a que puede haber muchos pozos en el mundo, y se espera programar algunos mundos muy grandes, es necesario una mecánica que permita poner más de un pozo a la vez, especificando alguna lógica para su emplazamiento, por ejemplo:

* `put pit in [?, ? : i == j];` Pone pozos por la diagonal donde la fila es igual a la columna.
* `rem pit in [2, ? : j = 2N];` Remueve pozos en la fila 2 donde la columna sea par.
* `put pit in [?, ? : i >j, i + j >= 3];` Pone pozos en las casillas cuya fila sea mayor a la columna y, además, la suma de la fila y columna sea mayor o igual a 3.

Cuando aparecen `?` en las filas y/o columnas, siempre se hará referencia a ellas con las variables `i` y `j` respectivamente.

Este método para hacer referencia a conjuntos de casillas debe soportar el conjunto de expresiones del siguiente cuadro.


| Expresión | Notación | Significado | Ejemplos |
|-|-|-|-|
| Aritméticas | +, −, ∗, \ | suma, resta, multiplicación, división entera | i + 3 <br/> j ∗ 2 + 5 <br/> i + j / 4 |
| Relaciones | ==, <, >, <=, >= | igual, menor, mayor, menor o igual, mayor o igual | i > 2 <br/> j <= 7 <br/> i + 3 == j |
| Forma | k=aN+b <br/> k=aN-b | k es de la forma aN+b, donde a y b pueden ser cualquier escalar o estar ausentes. | i = 2N → i = 0, 2, 4, 6, ...<br/> j = 3N − 1 → j = 0, 2, 5, 8, ... |

Cuando se utilizan expresiones, después de `:` todas las expresiones separadas por `,` deben evaluarse como un *AND* lógico.

Estas son las sentencias necesarias para definir el ambiente, pero se debe tener en cuenta que no puede haber conflictos en las casillas, o sea, no puede haber dos elementos diferentes en la misma casilla, por lo que se deja a discreción de la implementación como responde el interprete a instrucciones conflictivas.

Finalmente, es necesario implementar una sentencia que permita ver como está formado el mundo.

    print world;

Esta sentencia debe devolver a la salida estándar la información completa del mundo en formato csv de la siguiente forma:

    world,5,5
    wumpus,3,2
    gold,5,4
    hero,3,2
    pit,2,3
    pit,5,1
    pit,4,2
    ...

Donde `world` indica el tamaño del mundo, `wumpus` la posición del Wumpus, `gold` la posición del oro, `hero` la posición del heroe y `pit` la de cada pozo. El orden en que aparecen no es importante.

![El Wumpus](wumpus.png)
>>>>>>> f1afa1e5e591ef8f932ae75443728b054c1bdfe4
