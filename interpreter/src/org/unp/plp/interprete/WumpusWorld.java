package org.unp.plp.interprete;


import java.util.ArrayList;
import java.util.Collection;
import java.util.HashMap;
import java.util.HashSet;
import java.util.List;
import java.util.Map;
import java.util.Set;

import java.util.function.BiPredicate;
import java.util.function.BinaryOperator;

public class WumpusWorld {
	
	public int filas, columnas;
	private String objeto;

	private Map<String, Celda> objetosTablero = new HashMap<>();
	// Key-value (clave-valor)
	// el string cambiarlo por objeto gold, hero, wumpus, pit

	private Set<Celda> listaPits = new HashSet<>();
	/**
	 *
	 */
	
	

	
	public void iniciarMundo(int filas, int columnas) {

		this.filas = filas;
		this.columnas = columnas;

		

		objetosTablero.put("hero", new Celda(0,0));
		objetosTablero.put("gold", new Celda(this.filas-1,this.columnas-1));
		objetosTablero.put("wumpus", new Celda(this.filas-1,0));

		Matriz.world = this; // Registra en mundo en la clase matriz

    }

	public void poner(String objeto, int fila, int columna) {

		objetosTablero.put(objeto, new Celda(fila,columna));
		/**
		 this.objeto = objeto;
		Celda celda = new Celda(fila, columna);
		
		if (!objetosTablero.containsKey(this.objeto)){
			objetosTablero.put(this.objeto, celda);
		}else{
			objetosTablero.replace(this.objeto, objetosTablero.get(this.objeto), celda);
		}  **/


    }

  //  public void ponerPits(Set<Celda> pozo) {  }

	void eliminarPit(int fi , int col){
	Celda pit = new Celda(fi, col);
	listaPits.remove(pit);
	
	}

	void ponerPit(Celda celda){
		listaPits.add(celda);
	}

	void ponerPits(Collection<Celda> celdas){
		listaPits.addAll(celdas);
	}




	/** Set<Celda> generarConjunto(){

		Set<Celda> result = new HashSet<>();

		for(int i=0; i < filas; i++){
			for (int j=0; j< columanas; j++){

				if()
			}
		}
	}     **/

	// Aplica una condición a dos conjuntos de celdas
	// Si la condición es verdades, sólo genera la intersección de las celdas.
	List<Celda> condicion(List<Celda> as, List<Celda> bs, BiPredicate<Float, Float> p){
		
		List<Celda> rs = new ArrayList<>();

		Celda a = null;
		Celda b = null;

		while (!as.isEmpty() && !bs.isEmpty()){
			if 			(a == null || index(a) < index(b)) { a = as.remove(0); }
			else if (b == null || index(a) > index(b)) { b = bs.remove(0); }
			else {
				if (p.test(a.valor, b.valor)) rs.add(a);
				a = as.remove(0);
				b = bs.remove(0);
			}
		}

		return rs;
	}




	public void ponerOro(int filas, int columnas) {

		Celda celda = new Celda(filas, columnas);
		if (!objetosTablero.containsKey("GOLD")){
			objetosTablero.put("GOLD", celda);
		}else{
			objetosTablero.replace("GOLD", objetosTablero.get("GOLD"), celda);
		}
    }

	public void ponerWumpus(int filas, int columnas) {
		Celda celda = new Celda(filas, columnas);

		if (!objetosTablero.containsKey("WUMPUS")){
			objetosTablero.put("WUMPUS", celda);
		}else{
			objetosTablero.replace("WUMPUS", objetosTablero.get("WUMPUS"), celda);
		}
		
    }



	void imprimir(){
		System.out.println("world: " + filas + "," + columnas );
		
		for(Map.Entry<String,Celda> object : objetosTablero.entrySet()){
			System.out.println(object.getKey() + ": " + object.getValue());
		}

		for(Celda pit : listaPits){
			System.out.println("pit: " + pit);
		}		
	}

	private int index(Celda c){
		if(c == null) return -1;
		return c.fila * columnas + c.columna;
	}

	
}  // FIN CLASE WUMPUS WORLD


// inicio clase celda

class Celda {
	public int fila;
	public int columna;

	public float valor = 0;

	Celda(int fila, int columna){
		this.fila = fila;
		this.columna = columna;
	}

	Celda(int fila, int columna, float valor){
		this.fila = fila;
		this.columna = columna;
		this.valor = valor;
	}


	public String toString(){
		return fila + "," + columna;
	}

}



// inicio clase Matriz
class Matriz {

	/* De Clase */

	public static WumpusWorld world = null;

	// Genera la representación de valores
	public static Matriz constante(int valor){
		return new Matriz(world, valor, 0, 0);
	}

	public static Matriz i(){
		return new Matriz(world, 0, 1, 0);
	}

	public static Matriz j(){
		return new Matriz(world, 0, 0, 1);
	}

	public static Matriz operar(Matriz a, Matriz b, BinaryOperator<Float> f){
		for (int i = 0; i < world.filas; i++){
			for (int j = 0; j < world.columnas; j++){
				a.celda[i][j] = f.apply(a.celda[i][j], b.celda[i][j]);
			}
		}
		return a;
	}

	/* De Instancia */
	public float[][] celda;

	public Matriz(WumpusWorld w, int valor, int fi, int fj){

		celda = new float[w.filas][w.columnas];

		for (int i = 0; i < w.filas; i++){
			for (int j = 0; j < w.columnas; j++){
				celda[i][j] = valor + i*fi + j*fj;
			}
		}
	}

	// Convierte la matriz en un conjunto de celdas
	public List<Celda> celdas(){
		List<Celda> rs = new ArrayList<>();
		for (int i = 0; i < celda.length; i++){
			for (int j = 0; j < celda[i].length; j++){
				rs.add(new Celda(i, j, celda[i][j]));
			}
		}
		return rs;
	}
}