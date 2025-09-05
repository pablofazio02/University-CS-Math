package prLibreria;

/**
 * La clase OfertaAutor (del paquete prLibreria) implementa la interfaz
 * OfertaFlex y proporciona un método para calcular el porcentaje de descuento a
 * partir de los nombres de autores en oferta, ambos especficados en la
 * construcción del objeto.
 * 
 * @author Pablo Fazio Arrabal
 *
 */

public class OfertaAutor implements OfertaFlex {

	private double porcDescuento;

	private String[] autoresOferta;

	/**
	 * Construye un objeto con el porcentaje de descuento y el array con los nombres
	 * de los autores en oferta, recibidos como parámetros en ese mismo orden.
	 * 
	 * @param porcDescuento Double que nos dice el descuento del libro.
	 * @param autoresOferta Array de Strings que nos dice los libros que están en
	 *                      oferta según su autor.
	 */

	public OfertaAutor(double a, String[] vector) {

		porcDescuento = a;

		autoresOferta = vector;

	}

	/**
	 * Calcula y devuelve el porcentaje de descuento que se debe aplicar a un
	 * determinado libro recibido como parámetro si el nombre del autor se encuentra
	 * en el array de autores en oferta especificado en la construcción del objeto.
	 * En caso de que no se deba aplicar ningún descuento, devolverá el valor cero.
	 */

	public double getDescuento(Libro a) {

		double valor = 0.0;

		boolean found = false;
		int j = 0;

		while (j < autoresOferta.length && !found) {
			if (autoresOferta[j].equalsIgnoreCase(a.getAutor())) {

				valor = porcDescuento;

				found = true;
			}
			j++;
		}

		return valor;

	}

	/**
	 * Devuelve la representación textual del objeto, según el formato.
	 */

	public String toString() {

		String a = porcDescuento + "%[";

		for (int i = 0; i < autoresOferta.length; i++) {
			a += autoresOferta[i];

			if (i < autoresOferta.length - 1) {
				a += ", ";
			}
		}

		return a + "]";

	}
}
