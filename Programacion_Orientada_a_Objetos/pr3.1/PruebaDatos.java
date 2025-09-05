
import java.util.Arrays;

import prDatos.Datos;



public class PruebaDatos {

	public static void main(String[] args) {
		boolean found = false;
		
		if (args.length < 3) {
			System.err.println("Error, no hay valores suficientes");

		} else {
			
			try {
				Double.parseDouble(args[0]);
			} catch (NumberFormatException e) {
				System.err.println("Error, al convertir un valor a número real (" + e.getMessage() + ")");
				found =true;
			}

			try {
				Double.parseDouble(args[1]);
			} catch (NumberFormatException e) {
				System.err.println("Error, al convertir un valor a número real (" + e.getMessage() + ")");
				found=true;
			}
			
			if(!found) {
				Datos datos = new Datos(Arrays.copyOfRange(args, 2, args.length), Double.parseDouble(args[0]),
						Double.parseDouble(args[1]));

				System.out.println(datos);

				try {
					datos.setRango("0;4");
					System.out.println(datos);
				} catch (Exception e) {
					System.err.println(e.getMessage());
					
				}

				try {
					datos.setRango("15 25");
					System.out.println(datos);
				} catch (Exception e) {
					System.err.println(e.getMessage());
					 
				}
			}

		}

	}
}
