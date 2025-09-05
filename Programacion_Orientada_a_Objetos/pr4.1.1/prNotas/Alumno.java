package prNotas;

public class Alumno {

	private String nombre;
	
	private String dni;
	
	private double nota;
	
	public Alumno(String a, String b, double c) throws AlumnoException {
		if(c<0) {
			throw new AlumnoException("Calificación negativa");
		}
		dni=a;
		nombre=b;
		nota=c;
	}
	
	public Alumno(String a, String b) {
		dni=a;
		nombre=b;
		nota=0;
	}
	
	public String getNombre() {
		return nombre;
	}
	
	public String getDni() {
		return dni;
	}
	
	public double getCalificacion() {
		return nota;
	}
	
	public String toString() {
		return nombre +" "+dni;
	}
	
	public boolean equals (Object a) {
		boolean valor = (a instanceof Alumno);
		Alumno dos = valor ? (Alumno) a: null;
		return (valor&&(dni.equalsIgnoreCase(dos.dni))&&(nombre==dos.nombre));
	}
	
	public int hashCode() {
		return (nombre.hashCode()+dni.toLowerCase().hashCode());
	}
}
