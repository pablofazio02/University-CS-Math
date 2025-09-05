package prLibreria;

/**
 * La clase LibroOferta (del paquete prLibreria) deriva de la clase Libro, por
 * lo que contiene información sobre un determinado libro, pero además, permite
 * especificar un determinado porcentaje de descuento, que será aplicado al
 * precio base al calcular el precio final del libro.
 * 
 * @author Pablo Fazio Arrabal
 *
 */

public class LibroOferta extends Libro {

	private double porcDescuento;

	/**
	 * Construye un objeto LibroOferta. Recibe como parámetros, en el siguiente
	 * orden, el nombre del autor, el título, el precio base y el porcentaje de
	 * descuento del libro.
	 * 
	 * @param porcDescuento Double que nos dice el descuento del libro.
	 */

	public LibroOferta(String a, String b, double c, double d) {

		super(a, b, c);

		porcDescuento = d;

	}

	/**
	 * Devuelve el porcentaje de descuento del libro.
	 */

	public double getDescuento() {

		return porcDescuento;

	}

	public double getPrecioMedio() {

		double valor;

		valor = super.getPrecioBase() - ((super.getPrecioBase() * porcDescuento) / 100);

		return valor;
	}

	/**
	 * Devuelve el precio final del libro, aplicando el descuento al precio base, e
	 * incluyendo el IVA.
	 */

	public double getPrecioFinal() {

		double valorFinal;

		valorFinal = getPrecioMedio() + ((getPrecioMedio() * super.getIVA()) / 100);

		return valorFinal;

	}

	/**
	 * Devuelve la representación textual del objeto, según el formato: (autor;
	 * titulo; PB; descuento%; PM; IVA%; PF).
	 */

	public String toString() {

		return ("(" + super.getAutor() + "; " + super.getTitulo() + "; " + super.getPrecioBase() + "; " + porcDescuento
				+ "%; " + this.getPrecioMedio() + "; " + super.getIVA() + "%; " + this.getPrecioFinal() + ")");

	}

}
