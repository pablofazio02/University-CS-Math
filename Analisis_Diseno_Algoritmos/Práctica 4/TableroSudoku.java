// ALUMNO:
// GRUPO: 

import java.util.*;


public class TableroSudoku implements Cloneable {
	
	// constantes relativas al nº de filas y columnas del tablero
	protected static final int MAXVALOR=9; 
	protected static final int FILAS=9; 
	protected static final int COLUMNAS=9; 
							 
	protected static Random r = new Random();
	
	protected int celdas[][]; // una celda vale cero si est\u00E1 libre.
	
	public TableroSudoku() {
		celdas = new int[FILAS][COLUMNAS]; //todas a cero.
	}

	// crea una copia de su par\u00E1metro
	public TableroSudoku(TableroSudoku uno) {
		TableroSudoku otro = (TableroSudoku) uno.clone();
		this.celdas = otro.celdas;
	}

	// crear un tablero a parir de una configuraci\u00D3n inicial (las celdas vac\u00EDas
	// se representan con el caracter ".".
    public TableroSudoku(String s) {
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
		TableroSudoku clon;
		try {
			clon = (TableroSudoku) super.clone();
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
		if (obj instanceof TableroSudoku) {
			TableroSudoku otro = (TableroSudoku) obj;
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


	// devuelva true si la celda del tablero dada por fila y columna est\u00E1 vac\u00EDa.
	protected boolean estaLibre(int fila, int columna) {
		return celdas[fila][columna] == 0;
	}
	
	// devuelve el número de casillas libres en un sudoku.
	protected int numeroDeLibres() {
		int n=0;
	    for (int f = 0; f < FILAS; f++) 
	        for (int c = 0; c < COLUMNAS; c++)
	        	if(estaLibre(f,c))
	        		n++;
	    return n;
	}
	
	protected int numeroDeFijos() {
		return FILAS*COLUMNAS - numeroDeLibres();
	}

	// Devuelve true si @valor ya esta en la fila @fila.
	protected boolean estaEnFila(int fila, int valor) {
		for (int i = 0; i< COLUMNAS ; i++) {
			if (celdas[fila][i] == valor) return true;
		}
		return false;
	}    

	// Devuelve true si @valor ya esta en la columna @columna.
	protected boolean estaEnColumna(int columna, int valor) {
		for (int i = 0; i< FILAS ; i++) {
			if (celdas[i][columna] == valor) return true;
		}
		return false;
	}    
	

	// Devuelve true si @valor ya esta en subtablero al que pertence @fila y @columna.
	protected boolean estaEnSubtablero(int fila, int columna, int valor) {
		for (int i=(3*(fila/3)); i<3*(1+(fila/3)); i++) {
			for (int u=(3*(columna/3)); u<3*(1+columna/3); u++) {
				if (celdas[i][u] == valor) return true;
			}
		}
		return false;
	}    

	
	// Devuelve true si se puede colocar el @valor en la @fila y @columna dadas.
	protected boolean sePuedePonerEn(int fila, int columna, int valor) {
		return !estaEnColumna(columna,valor) &&
				!estaEnFila(fila,valor) &&
				!estaEnSubtablero(fila,columna,valor);
	}



/*
	protected void resolverTodos(List<TableroSudoku> soluciones, int fila, int columna) {
		boolean continuar = true;
		for (int i = fila ; continuar && i < FILAS ; i++) {
			for (int u = columna ; continuar && u < COLUMNAS ; u++){
				// Busco el primero vacío
				if (celdas [i][u] == 0) {
					for (int k = 1; k <= MAXVALOR; k++) {
						if (sePuedePonerEn(i, u, k)) {
							celdas[i][u] = k;
							if (numeroDeLibres() == 0) {
								soluciones.add(new TableroSudoku(this));
							} else {
								resolverTodos(soluciones, i, u);
							}
						}
					} // valores
					celdas[i][u] = 0;
					continuar = false;
				}
			} // columnas
		} // filas
	}
	*/


	protected void resolverTodos(List<TableroSudoku> soluciones, int fila, int columna) {
		int [] next = nextEmpty(fila,columna);
		if (next == null) soluciones.add(new TableroSudoku(this));
		else {
			int f = next[0];
			int c = next[1];
			for (int k = 1 ; k<=MAXVALOR ; k++){
				if (sePuedePonerEn(f,c,k)) {
					celdas[f][c] = k;
					resolverTodos(soluciones,f,c);
				}
			}
			celdas[f][c] = 0;
		}
	}

	private int[] nextEmpty(int fila, int columna) {
		int i = fila;
		int u = columna;
		while (i != FILAS) {
			if (celdas[i][u] == 0) return new int[] {i,u};
			u++;
			if (u == COLUMNAS) {
				u = 0;
				i++;
			}
		}
		return null;
	}

	public List<TableroSudoku> resolverTodos() {
        List<TableroSudoku> sols  = new LinkedList<TableroSudoku>();
        resolverTodos(sols, 0, 0);
		return sols;
	}
	
	
	public static void main(String arg[]) {
		TableroSudoku t = new TableroSudoku( 
			    ".4....36263.941...5.7.3.....9.3751..3.48.....17..62...716.9..2...96.......312..9.");
		List<TableroSudoku> lt = t.resolverTodos();
		System.out.println(t);
		System.out.println(lt.size());
		for(Iterator<TableroSudoku> i= lt.iterator(); i.hasNext();) {
			TableroSudoku ts = i.next(); 
			System.out.println(ts);
			
		}

	}
	
	
}
