import prNotas.Alumno;
import prNotas.AlumnoException;

public class PruebaAlumno {

	public static void main(String[] args) throws AlumnoException {
		
		Alumno primero = new Alumno("22456784F", "Gonzalez Perez, Juan",5.5);
		
		Alumno segundo = new Alumno("33456777S", "Gonzalez Perez, Juan",3.4);
			
		System.out.println(primero.getNombre()+" Nota: "+primero.getCalificacion());
		
		System.out.println(segundo.getNombre()+" Nota: "+segundo.getCalificacion());
		
		segundo = new Alumno("33456777S", "Gonzalez Perez, Juan",-3.4);
		
	}

}
