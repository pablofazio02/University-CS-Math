package prDatos;

import java.util.Arrays;

public class Datos {

	private double[] datos = new double[1];

	private String[] errores = new String[1];

	private double min;

	private double max;

	public Datos(String[] a, double b, double c) {

		datos = Arrays.copyOf(datos, a.length);
		errores = Arrays.copyOf(errores, a.length);

		int valores = 0;
		int valor = 0;

		for (int i = 0; i < a.length; i++) {
			try {
				datos[valores] = Double.parseDouble(a[i]);
				valores++;
			} catch (NumberFormatException nfe) {
				errores[valor] = a[i];
				valor++;
			}
		}

		min = b;
		max = c;

		datos = Arrays.copyOf(datos, valores);
		errores = Arrays.copyOf(errores, valor);
	}

	public double calcMedia() throws DatosException {
		double valores = 0;
		double suma = 0;

		for (int i = 0; i < datos.length; i++) {
			if (datos[i] >= min) {
				if (datos[i] <= max) {
					if (datos[i] != 0) {
						suma += datos[i];
						valores++;
					}
				}
			}
		}

		if (valores == 0) {
			throw new DatosException("No hay datos en el rango especificado");
		}

		return (suma / valores);
	}

	public double calcDesvTipica() throws DatosException {
		double suma = 0;
		double media = this.calcMedia();
		int valores = 0;
		
		for (int i = 0; i < datos.length; i++) {
			if (datos[i] >= min) {
				if (datos[i] <= max) {
					if (datos[i] != 0) {
						suma += Math.pow(datos[i] - media, 2);
						valores++;
					}
				}
			}
		}

		return (Math.sqrt(suma / valores));
	}

	public void setRango(String a) throws DatosException {
		try {
			String[] item = a.split(";");
			min = Double.parseDouble(item[0]);
			max = Double.parseDouble(item[1]);
		} catch (Exception e) {
			throw new DatosException("Error en los datos al establecer el rango"); 
		}
	}

	public double[] getDatos() {
		return datos;
	}

	public String[] getErrores() {
		return errores;
	}

	public String toString() {
		String cad = "Min: " + min + ", Max: " + max + ", [";
		for (int i = 0; i < datos.length; i++) {
			cad += datos[i];
			if (i < datos.length - 1) {
				cad += ", ";
			}
		}
		cad += "], [";
		for (int i = 0; i < errores.length; i++) {
			cad += errores[i];
			if (i < errores.length - 1) {
				cad += ", ";
			}
		}

		try {
			cad += "], Media: " + calcMedia() + ", DesvTipica: " + calcDesvTipica();
		} catch (Exception e) {
			cad += "], Media: ERROR, DesvTipica: ERROR";
		}

		return cad;
	}
}
