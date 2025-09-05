package prNotas;

public class MediaAritmetica implements CalculoMedia{

	public MediaAritmetica() {
		super();
	}
	
	public double calcular (Alumno[] a) throws AlumnoException {
		if(a.length==0) {
			throw new AlumnoException("No hay alumnos");
		}
		
		double suma = 0;
		
		for (int i =0; i<a.length; i++) {
			suma+=a[i].getCalificacion();
		}
		
		return (suma/a.length);
	}
}
