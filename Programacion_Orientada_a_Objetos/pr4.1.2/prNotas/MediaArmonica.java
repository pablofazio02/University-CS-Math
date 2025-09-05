package prNotas;

public class MediaArmonica implements CalculoMedia{

	public MediaArmonica() {
		super();
	}
	
	public double calcular (Alumno [] a) throws AlumnoException {
		if(a.length==0) {
			throw new AlumnoException("No hay alumnos");
		}
		
		double valores = 0;
		double suma = 0;
		
		for(int i = 0; i<a.length; i++) {
			if(a[i].getCalificacion()>0) {
				suma+=1/a[i].getCalificacion();
				valores++;
			}
		}
		
		return (valores/suma);
		
	}
}
