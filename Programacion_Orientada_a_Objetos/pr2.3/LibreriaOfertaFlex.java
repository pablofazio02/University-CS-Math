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
	 * Construye un objeto LibreriaOfertaFlex vac�o (sin libros) con una librer�a
	 * base con una capacidad inicial por defecto. Adem�s almacena la referencia al
	 * objeto para calcular las ofertas de los libros, que se recibe como primer
	 * par�metro.
	 * 
	 * @param oferta
	 */

	public LibreriaOfertaFlex(OfertaFlex a) {

		super();

		oferta = a;

	}

	/**
	 * Construye un objeto LibreriaOfertaFlex vac�o (sin libros) con una librer�a
	 * base con una capacidad inicial del tama�o recibido como primer par�metro.
	 * Adem�s almacena la referencia al objeto para calcular las ofertas de los
	 * libros, que se recibe como segundo par�metro.
	 */

	public LibreriaOfertaFlex(int a, OfertaFlex b) {

		super(a);

		oferta = b;

	}

	/**
	 * Actualiza el valor del objeto para calcular ofertas de libros al objeto
	 * recibido como par�metro.
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
	 * Crea un nuevo objeto Libro con el nombre del autor, el t�tulo, y el precio
	 * base recibidos como par�metros. Si el porcentaje de descuento calculado para
	 * este libro es distinto de cero, entonces vuelve a crear un nuevo objeto
	 * LibroOferta con el nombre del autor, el t�tulo, y el precio base recibidos
	 * como par�metros, y el descuento seg�n el valor calculado por el objeto para
	 * el c�lculo de las ofertas.
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
	 * Devuelve la representaci�n textual del objeto, seg�n el formato del siguiente
	 * ejemplo (sin considerar los saltos de l�nea). En la primera l�nea aparecer�
	 * la informaci�n del tipo de oferta que se est� realizando (en este caso se
	 * trata de una oferta del 20 % por autores). El resto de informaci�n mostrar�
	 * los libros almacenados en la librer�a.
	 */

	public String toString() {

		return (oferta.toString() + " " + super.toString());

	}
}
