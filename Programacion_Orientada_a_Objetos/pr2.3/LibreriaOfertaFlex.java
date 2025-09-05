package prLibreria;

/**
 * La clase LibreriaOfertaFlex (del paquete prLibreria) deriva de la clase
 * Libreria, pero permite crear y almacenar libros en oferta. Para ello,
 * contiene una referencia a un objeto que implemente la intefaz OfertaFlex.
 * 
 * @author Pablo Fazio Arrabal
 *
 */

public class LibreriaOfertaFlex extends Libreria {

	private OfertaFlex oferta;

	/**
	 * Construye un objeto LibreriaOfertaFlex vacío (sin libros) con una librería
	 * base con una capacidad inicial por defecto. Además almacena la referencia al
	 * objeto para calcular las ofertas de los libros, que se recibe como primer
	 * parámetro.
	 * 
	 * @param oferta
	 */

	public LibreriaOfertaFlex(OfertaFlex a) {

		super();

		oferta = a;

	}

	/**
	 * Construye un objeto LibreriaOfertaFlex vacío (sin libros) con una librería
	 * base con una capacidad inicial del tamaño recibido como primer parámetro.
	 * Además almacena la referencia al objeto para calcular las ofertas de los
	 * libros, que se recibe como segundo parámetro.
	 */

	public LibreriaOfertaFlex(int a, OfertaFlex b) {

		super(a);

		oferta = b;

	}

	/**
	 * Actualiza el valor del objeto para calcular ofertas de libros al objeto
	 * recibido como parámetro.
	 */

	public void setOferta(OfertaFlex a) {

		oferta = a;

	}

	/**
	 * Devuelve el objeto para calcular ofertas de libros.
	 */

	public OfertaFlex getOferta() {

		return oferta;

	}

	/**
	 * Crea un nuevo objeto Libro con el nombre del autor, el título, y el precio
	 * base recibidos como parámetros. Si el porcentaje de descuento calculado para
	 * este libro es distinto de cero, entonces vuelve a crear un nuevo objeto
	 * LibroOferta con el nombre del autor, el título, y el precio base recibidos
	 * como parámetros, y el descuento según el valor calculado por el objeto para
	 * el cálculo de las ofertas.
	 */

	public void addLibro(String a, String b, double c) {

		Libro nuevo = new Libro(a, b, c);

		double ver = oferta.getDescuento(nuevo);

		if (ver != 0) {

			LibroOferta nueva = new LibroOferta(a, b, c, ver);
			anyadirLibro(nueva);

		} else {
			anyadirLibro(nuevo);
		}

	}

	/**
	 * Devuelve la representación textual del objeto, según el formato del siguiente
	 * ejemplo (sin considerar los saltos de línea). En la primera línea aparecerá
	 * la información del tipo de oferta que se está realizando (en este caso se
	 * trata de una oferta del 20 % por autores). El resto de información mostrará
	 * los libros almacenados en la librería.
	 */

	public String toString() {

		return (oferta.toString() + " " + super.toString());

	}
}
