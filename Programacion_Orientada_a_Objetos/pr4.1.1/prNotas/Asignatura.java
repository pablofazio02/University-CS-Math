package prNotas;

import java.util.Arrays;
import java.util.StringJoiner;

public class Asignatura {

	private String nombre;
	
	private String[] errores = new String[1];
	
	private Alumno [] alumnos = new Alumno[1];
	
	public Asignatura (String a, String [] b){
		
		nombre = a;
		int valor=0;
		int valores=0;
		
		alumnos = Arrays.copyOf(alumnos, b.length);
		errores = Arrays.copyOf(errores, b.length);
		
		
		for(int i=0; i<b.length; i++) {
			try {
				String[] item= b[i].split("[;]");
				alumnos[valores]= new Alumno(item[0], item[1], Double.parseDouble(item[2]));
				valores++;
			}catch(IndexOutOfBoundsException ie) {
				errores[valor]="ERROR. Faltan datos: "+b[i];
				valor++;
			}catch(NumberFormatException ne) {
				errores[valor]="ERROR. Calificacion no numerica: "+b[i];
				valor++;
			}catch(Exception e) {
				errores[valor]="ERROR. "+e.getMessage()+": "+b[i];
				valor++;
			}
		}
		
		alumnos = Arrays.copyOf(alumnos, valores);
		errores = Arrays.copyOf(errores, valor);
	}
	
	public double getCalificacion(Alumno alu) throws AlumnoException {
		
		double valor=-1;
		boolean found=false;
		int i=0;
		
		while(i<alumnos.length&&!found) {
			if(alu.hashCode()==alumnos[i].hashCode()) {
				valor=alumnos[i].getCalificacion();
				found=true;
			}else{
				i++;
			}
		}
		
		if(valor==-1) {
			throw new AlumnoException("El alumno "+alu+" no se encuentra");
		}
		
		return valor;
	}
	
	public double getMedia() throws AlumnoException{
		if(alumnos.length==0) {
			throw new AlumnoException("No hay alumnos");
		}
		
		double suma=0;
		
		for(int i=0; i<alumnos.length; i++) {
			suma+=alumnos[i].getCalificacion();
		}
		
		return (suma/alumnos.length);
		
	}
	
	 public double getMedia(CalculoMedia media) throws AlumnoException{
		 if (alumnos.length == 0){
				throw new AlumnoException("No hay alumnos");
			}
			
			return media.calcular(alumnos);
	 }
	
	public Alumno[] getAlumnos(){
		return alumnos;
	}
	
	public String [] getErrores() {
		return errores;
	}
	
	public String toString() {
		StringJoiner sj= new StringJoiner(", ", "[", "]");
		for(int i=0; i<alumnos.length; i++) {
			sj.add(alumnos[i].toString());
		}
		StringJoiner js= new StringJoiner(", ", "[", "]");
		for(int i=0; i<errores.length; i++) {
			js.add(errores[i]);
		}
		return nombre +": {"+sj+", "+js+"}";
	}
	
	
}
