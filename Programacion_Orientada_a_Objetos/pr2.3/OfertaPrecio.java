package prLibreria;

/**
 * La clase OfertaPrecio (del paquete prLibreria) implementa la interfaz
 * OfertaFlex y proporciona un método para calcular el porcentaje de descuento a
 * partir de un determinado umbral en el precio base del libro, ambos
 * especficados en la construcción del objeto.
 * 
 * @author Pablo Fazio Arrabal
 *
 */

public class OfertaPrecio implements OfertaFlex {

	private double porcDescuento;

	private double umbralPrecio;

	/**
	 * Construye un objeto con el porcentaje de descuento y el umbral del precio,
	 * recibidos como parámetros en ese mismo orden.
	 * 
	 * @param porcDescuento Double que indica el descuento de dicho libro.
	 * @param umbralPrecio  Double que indica el precio minimo necesario para que el
	 *                      libro tenga descuento.
	 */

	public OfertaPrecio(double a, double b) {

		porcDescuento = a;

		umbralPrecio = b;

	}

	/**
	 * Calcula y devuelve el porcentaje de descuento que se debe aplicar a un
	 * determinado libro recibido como parámetro si el precio base del libro es
	 * mayor o igual al umbral especificado en la construcción del objeto. En caso
	 * de que no se deba aplicar ningún descuento, devolverá el valor cero.
	 */

	public double getDescuento(Libro a) {

		double valor = 0.0;

		if (umbralPrecio <= a.getPrecioBase()) {
			valor = porcDescuento;
		}

		return valor;
	}

	/**
	 * Devuelve la representación textual del objeto, según el formato.
	 */

	public String toString() {

		return porcDescuento + "%(" + umbralPrecio + ")";

	}
}
