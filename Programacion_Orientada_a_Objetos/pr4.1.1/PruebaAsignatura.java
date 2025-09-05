import prNotas.Alumno;
import prNotas.AlumnoException;
import prNotas.Asignatura;

public class PruebaAsignatura {

	public static void main(String[] args) throws AlumnoException {
		
	String[] alum = {
				"12455666F;Lopez Perez, Pedro;6.7",
				"33678999D;Merlo Gomez, Isabel;5.8",
				"23555875G;Martinez Herrera, Lucia;9.1",
	};
	
	Asignatura nueva = new Asignatura("POO", alum);
	
	System.out.println("Media de notas:" + nueva.getMedia());
	
	for (Alumno alumno : nueva.getAlumnos()) {
		System.out.println("DNI: " + alumno.getDni());
	}
	
	System.out.println("Nota: "+ nueva.getCalificacion(new Alumno("12455666F", "Lopez Perez, Pedro")));
	
	}

}
