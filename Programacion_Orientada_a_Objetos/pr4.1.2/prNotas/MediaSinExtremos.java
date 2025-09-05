package prNotas;

public class MediaSinExtremos implements CalculoMedia{

	private double min;
	
	private double max;
	
	public MediaSinExtremos(double a, double b){
		min=a;
		max=b;
	}
	
	public double calcular (Alumno[] a)  throws AlumnoException {
		double valores=0;
		double suma = 0;
		
		for(int i=0; i<a.length; i++) {
			if(min<=a[i].getCalificacion()&&max>=a[i].getCalificacion()) {
				valores++;
				suma+=a[i].getCalificacion();
			}
		}
		
		if(valores==0) {
			throw new AlumnoException("No hay alumnos");
		}
		
		return (suma/valores);
	}
	
	public double getMin() {
		return min;
	}
	
	public double getMax() {
		return max;
	}
}
