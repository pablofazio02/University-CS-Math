package prLibreria;

/**
 * La interfaz OfertaFlex (del paquete prLibreria) especifica los m�todos
 * necesarios para calcular el porcentaje de descuento que se debe aplicar a un
 * determinado libro.
 * 
 * @author Pablo Fazio Arrabal
 *
 */

public interface OfertaFlex {

	/**
	 * Calcula y devuelve el porcentaje de descuento que se debe aplicar a un determinado libro recibido
	 * como par�metro. En caso de que no se deba aplicar ning�n descuento, devolver� el valor cero.
	 */
	
	public double getDescuento(Libro a);

	

}
