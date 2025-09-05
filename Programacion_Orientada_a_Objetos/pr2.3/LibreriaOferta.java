package prLibreria;

/**
 * La clase LibreriaOferta (del paquete prLibreria) deriva de la clase Libreria,
 * pero permite crear y almacenar libros en oferta. Para ello, contiene adem�s
 * un array con los nombres de los autores en oferta, as� como del porcentaje de
 * oferta a aplicar a los libros de estos autores.
 * 
 * @author Pablo Fazio Arrabal
 *
 */

public class LibreriaOferta extends Libreria {

	private double porcDescuento;

	private String[] autoresOferta;

	/**
	 * Construye un objeto LibreriaOferta vac�o (sin libros) con una librer�a base
	 * con una capacidad inicial por defecto. Adem�s el porcentaje de descuento se
	 * recibe como primer par�metro, y el array con los nombres de los autores en
	 * oferta se recibe como segundo par�metro.
	 * 
	 * @param porcDescuento Double que nos dice el descuento de la libreria.
	 * @param autoresOferta Array de Strings que nos dice los libros que est�n en
	 *                      oferta seg�n su autor.
	 */

	public LibreriaOferta(double a, String[] libros) {

		super();

		porcDescuento = a;

		autoresOferta = libros;

	}

	/**
	 * Construye un objeto LibreriaOferta vac�o (sin libros) con una librer�a base
	 * con una capacidad inicial del tama�o recibido como primer par�metro. Adem�s
	 * el porcentaje de descuento se recibe como segundo par�metro, y el array con
	 * los nombres de los autores en oferta se recibe como tercer par�metro.
	 */

	public LibreriaOferta(int a, double b, String[] libros) {

		super(a);

		porcDescuento = b;

		autoresOferta = libros;

	}

	/**
	 * Actualiza el valor del porcentaje de descuento y reemplaza el array de
	 * autores en oferta con los valores recibidos como par�metros.
	 */

	public void setOferta(double a, String[] array) {

		porcDescuento = a;

		autoresOferta = array;

	}

	/**
	 * Devuelve el array de autores en oferta.
	 */

	public String[] getOferta() {

		return autoresOferta;

	}

	/**
	 * Devuelve el porcentaje de descuento.
	 */

	public double getDescuento() {

		return porcDescuento;

	}

	/**
	 * Si el nombre del autor recibido como primer par�metro es igual a alg�n autor
	 * de la lista de autores en oferta, entonces crea un nuevo objeto LibroOferta
	 * con el nombre del autor, el t�tulo, y el precio base recibidos como
	 * par�metros, y el descuento seg�n el valor almacenado. En otro caso, crea un
	 * nuevo objeto Libro con el nombre del autor, el t�tulo, y el precio base
	 * recibidos como par�metros.
	 */

	public void addLibro(String a, String b, double c) {

		boolean found = false;
		int j = 0;

		while (j < autoresOferta.length && !found) {
			if (autoresOferta[j].equalsIgnoreCase(a)) {

				LibroOferta nuevo = new LibroOferta(a, b, c, porcDescuento);

				super.anyadirLibro(nuevo);

				found = true;
			}
			j++;
		}

		if (!found) {
			Libro nueva = new Libro(a, b, c);

			super.anyadirLibro(nueva);
		}

	}

	/**
	 * Devuelve la representaci�n textual del objeto, seg�n el formato.
	 */

	public String toString() {
		String a = porcDescuento + "%[";

		for (int i = 0; i < autoresOferta.length; i++) {
			a += autoresOferta[i];

			if (i < autoresOferta.length - 1) {
				a += ", ";
			}
		}

		return a + "]" + super.toString();
	}

}
