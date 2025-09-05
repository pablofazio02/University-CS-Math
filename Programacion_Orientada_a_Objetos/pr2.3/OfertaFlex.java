package prLibreria;

/**
 * La interfaz OfertaFlex (del paquete prLibreria) especifica los métodos
 * necesarios para calcular el porcentaje de descuento que se debe aplicar a un
 * determinado libro.
 * 
 * @author Pablo Fazio Arrabal
 *
 */

public interface OfertaFlex {

	/**
	 * Calcula y devuelve el porcentaje de descuento que se debe aplicar a un determinado libro recibido
	 * como parámetro. En caso de que no se deba aplicar ningún descuento, devolverá el valor cero.
	 */
	
	public double getDescuento(Libro a);

	

}
