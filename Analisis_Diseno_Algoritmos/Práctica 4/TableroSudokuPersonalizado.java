// ALUMNO:
// GRUPO: 

import java.util.*;


public class TableroSudokuPersonalizado implements Cloneable {
	
	// constantes relativas al nº de filas y columnas del tablero
	protected static final int MAXVALOR=9; 
	protected static final int FILAS=9; 
	protected static final int COLUMNAS=9; 
							 
	protected static Random r = new Random();
	
	protected int [][] celdas; // una celda vale cero si está libre.
	
	public TableroSudokuPersonalizado() {
		celdas = new int[FILAS][COLUMNAS]; //todas a cero.
	}

	// crea una copia de su parámetro
	public TableroSudokuPersonalizado(TableroSudokuPersonalizado uno) {
		TableroSudokuPersonalizado otro = (TableroSudokuPersonalizado) uno.clone();
		this.celdas = otro.celdas;
	}

	// crear un tablero a parir de una configuración inicial (las celdas vacías
	// se representan con el caracter ".".
    public TableroSudokuPersonalizado(String s) {
    	this();
    	if(s.length() != FILAS*COLUMNAS) {
    		throw new RuntimeException("Construcci\u00D3n de sudoku no v\u00E1lida.");
    	} else {
    		for(int f=0;f<FILAS;f++) 
				for(int c=0;c<COLUMNAS;c++) {
					Character ch = s.charAt(f*FILAS+c);
					celdas[f][c] = (Character.isDigit(ch) ? Integer.parseInt(ch.toString()) : 0 ); 
				}		
		}		
    }

	
	/* Realizar una copia en profundidad del objeto
	 * @see java.lang.Object#clone()
	 */
	public Object clone()  {
		TableroSudokuPersonalizado clon;
		try {
			clon = (TableroSudokuPersonalizado) super.clone();
			clon.celdas = new int[FILAS][COLUMNAS]; 
			for(int i=0; i<celdas.length; i++)
				System.arraycopy(celdas[i], 0, clon.celdas[i], 0, celdas[i].length);
		} catch (CloneNotSupportedException e) {
			clon = null;
		}	
		return clon;
	}
	
	/* Igualdad para la clase
	 * @see java.lang.Object#equals()
	 */
	public boolean equals(Object obj) {
		if (obj instanceof TableroSudokuPersonalizado) {
			TableroSudokuPersonalizado otro = (TableroSudokuPersonalizado) obj;
			for(int f=0; f<FILAS; f++)
				if(!Arrays.equals(this.celdas[f],otro.celdas[f]))
					return false;
			return true;		
		} else
			return false;
	}
	


	public String toString() {
		String s = "";

		for(int f=0;f<FILAS;f++) {
			for(int c=0;c<COLUMNAS;c++) 
				s += (celdas[f][c]==0 ? "." : String.format("%d",celdas[f][c])); 
		}
		return s;
	}


	// devuelva true si la celda del tablero dada por fila y columna está vacía.
	protected boolean estaLibre(int fila, int columna) {
		return celdas[fila][columna] == 0;
	}
	
	// devuelve el número de casillas libres en un sudoku.
	protected int numeroDeLibres() {
		int n=0;
	    for (int f = 0; f < FILAS; f++) 
	        for (int c = 0; c < COLUMNAS; c++)
	        	if (estaLibre(f,c))
	        		n++;
	    return n;
	}
	
	protected int numeroDeFijos() {
		return FILAS*COLUMNAS - numeroDeLibres();
	}

	// Devuelve true si @valor ya esta en la fila @fila.
	protected boolean estaEnFila(int fila, int valor) {
		boolean esta = false;

		int j = 0;
		while(j < COLUMNAS && !esta){
			if (celdas[fila][j] == valor){
				esta = true;
			}
			j++;
		}

		return esta;
	}    

	// Devuelve true si @valor ya esta en la columna @columna.
	protected boolean estaEnColumna(int columna, int valor) {
		boolean esta = false;

		int i = 0;
		while(i < FILAS && !esta){
			if (celdas[i][columna] == valor){
				esta = true;
			}
			i++;
		}

		return esta;
	}    
	

	// Devuelve true si @valor ya esta en subtablero al que pertence @fila y @columna.
	protected boolean estaEnSubtablero(int fila, int columna, int valor) {
		int subFila = fila/3;
		int subColumna = columna/3;

		if (subFila == 0 && subColumna == 0) {
			fila = 1;
			columna = 1;
		} else if (subFila == 0 && subColumna == 1) {
			fila = 1;
			columna = 4;
		} else if (subFila == 0 && subColumna == 2) {
			fila = 1;
			columna = 7;
		} else if (subFila == 1 && subColumna == 0) {
			fila = 4;
			columna = 1;
		} else if (subFila == 1 && subColumna == 1) {
			fila = 4;
			columna = 4;
		} else if (subFila == 1 && subColumna == 2) {
			fila = 4;
			columna = 7;
		} else if (subFila == 2 && subColumna == 0) {
			fila = 7;
			columna = 1;
		} else if (subFila == 2 && subColumna == 1) {
			fila = 7;
			columna = 4;
		} else if (subFila == 2 && subColumna == 2) {
			fila = 7;
			columna = 7;
		}

		boolean esta = false;
		int i = -1;
		while (i < 2 && !esta) {
			int j = -1;
			while (j < 2 && !esta) {
				if (celdas[fila+i][columna+j] == valor){
					esta = true;
				}
				j++;
			}
			i++;
		}

		return esta;
	}    

	
	// Devuelve true si se puede colocar el @valor en la @fila y @columna dadas.
	protected boolean sePuedePonerEn(int fila, int columna, int valor) {
		boolean sePuede = false;

		//El if no comprueba si la celda está vacía o no
		if (!estaEnSubtablero(fila,columna,valor) && !estaEnColumna(columna, valor) && !estaEnFila(fila, valor)) {
			sePuede = true;
		}
		return sePuede;
	}
	
	
	

	protected void resolverTodos(List<TableroSudokuPersonalizado> soluciones, int fila, int columna) {
		if (numeroDeFijos() == 9*9) { // si el sudoku está lleno tenemos una solución
			soluciones.add(new TableroSudokuPersonalizado(this)); // Añadimos el sudoku al conjunto de posibles soluciones del sudoku
		} else if (estaLibre(fila,columna)) { //Si hay un hueco libre

			int [] posiblesSiguientesSoluciones = conjuntoSoluciones(fila,columna); // Un array con números de 1 al 9, que son los posibles números que pueden ir en celdas[fila][columna]
			int i = 0; //para coger las distinas posibles soluciones del array

			while (posiblesSiguientesSoluciones.length > i) { //Si i es mayor que la longitud del array ya no nos quedan soluciones por probar
				int posibleNumero = posiblesSiguientesSoluciones[i]; //Cogemos los distintos posibles valores que podemos usar
				i++;

				TableroSudokuPersonalizado copia = new TableroSudokuPersonalizado(this); //Hacemos uan copia del Suduko que tenemos para no sobre escribir los datos

				copia.celdas[fila][columna] = posibleNumero; //Actualizamos valor de la copia del sudoku

				int newColumna = columna + 1; //Creamos una copia de columna y fila ya que al modificarlo antes de llamar a la función de forma recursiva si volvemos a este nodo la columna se habrá modificado
				int newFila = fila;

				if (newColumna == 9) { //Pasamos a la siguinte columna, si esa columna se sale de rango la ponemos a 0 y aumentamos la fila.
					newColumna = 0;
					newFila++;
				}
				copia.resolverTodos(soluciones, newFila, newColumna);//LLmamamos a la funcion con la celda siguiente
			}

		} else { //Si el hueco está ocupado pasamos a la siguinte columna, si esa columna se sale de rango la ponemos a 0 y aumentamos la fila. No hace falta hacer copia de fila y columna ya que no modificaremos nada aquí
			columna++; //aunque si hiciera una copia funcionaría igual
			if (columna == 9) {
				columna = 0;
				fila++;
			}
			resolverTodos(soluciones, fila, columna); //LLmamamos a la funcion con la celda siguiente
		}
	}

	private int[] conjuntoSoluciones(int fila, int columna) {
		int [] posSoluciones = new int[9];
		int longitud = 0;
		for (int i = 1; i <= posSoluciones.length; i++) {
			if (sePuedePonerEn(fila,columna,i)) {
				posSoluciones[longitud] = i;
				longitud++;
			}
		}

		return Arrays.copyOf(posSoluciones,longitud);
	}


	public List<TableroSudokuPersonalizado> resolverTodos() {
        List<TableroSudokuPersonalizado> sols  = new LinkedList<TableroSudokuPersonalizado>();
        resolverTodos(sols, 0, 0);
		return sols;
	}

	public void hacerSudokus(TableroSudokuPersonalizado a) {
		for (int i = 0; i < 9; i++) {
			for (int j = 0; j < 9; j++){

			}
		}
	}

	
	public static void main(String arg[]) {
		//TableroSudokuPersonalizado t = new TableroSudokuPersonalizado(
		//	    ".4....36263.941...5.7.3.....9.3751..3.48.....17..62...716.9..2...96.......312..9.");
		TableroSudokuPersonalizado t = new TableroSudokuPersonalizado(
			    "...9.7...82....3.......41.6.59..6....6.8.24.....3...9...27....36.7...8.4...6..51.");

		List<TableroSudokuPersonalizado> lt = t.resolverTodos();
		System.out.println(t);
		System.out.println(lt.size());


		/*for (Iterator<TableroSudoku> i= lt.iterator(); i.hasNext();) {
			TableroSudoku ts = i.next();
			System.out.println(ts);
		}*/
		int i = 0;
		int espacio = 1;
		int enter = 1;
		while (i < lt.size()){
			TableroSudokuPersonalizado ts = lt.get(i);
			for (int k = 0; k < 9; k++) {
				for (int j = 0; j < 9; j++){
					int [][] celdas = ts.celdas;
					System.out.print(celdas[k][j]);

					espacio++;
					if (espacio == 4) {
						espacio = 1;
						System.out.print("  ");
					}
				}
				System.out.println();
				enter++;
				if (enter == 4) {
					enter = 1;
					System.out.println();
				}

			}
			System.out.println();
			System.out.println();
			System.out.println();
			i++;
		}


	}
	
	
}
