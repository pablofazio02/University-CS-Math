import prLibreria.LibreriaOfertaFlex;
import prLibreria.OfertaAutor;



public class PruebaLibreriaOfertaFlex {

	public static void main(String[] args) {
		
		String[] libros = new String [2];
		libros [0]="George Orwell";
		libros [1]="Isaac Asimov";
		
		OfertaAutor a = new OfertaAutor(20, libros);
		
		LibreriaOfertaFlex novedad = new LibreriaOfertaFlex(a);
		
		novedad.addLibro("george orwell", "1984", 8.20);
		novedad.addLibro("Philip K. Dick", "�Sue�an los androides con ovejas el�ctricas?", 3.50);
		novedad.addLibro("Isaac Asimov", "Fundaci�n e Imperio", 9.40);
		novedad.addLibro("Ray Bradbury", "Fahrenheit 451", 7.40);
		novedad.addLibro("Aldous Huxley", "Un Mundo Feliz", 6.50);
		novedad.addLibro("Isaac Asimov", "La Fundaci�n", 7.30);
		novedad.addLibro("William Gibson", "Neuromante", 8.30);
		novedad.addLibro("Isaac Asimov", "Segunda Fundaci�n", 8.10);
		novedad.addLibro("Isaac Newton", "arithmetica universalis", 7.50);
		novedad.addLibro("George Orwell", "1984", 6.20);
		novedad.addLibro("Isaac Newton", "Arithmetica Universalis", 10.50);
		
		System.out.println (novedad);
		
		novedad.remLibro("George Orwell", "1984");
		novedad.remLibro("Aldous Huxley", "Un Mundo Feliz");
		novedad.remLibro("Isaac Newton", "Arithmetica Universalis");
		novedad.remLibro("James Gosling", "The Java Language Specification");
		
		System.out.println (novedad);
		
		System.out.println("PrecioFinal(George Orwell, 1984):"+novedad.getPrecioFinal("George Orwell", "1984"));
		System.out.println("PrecioFinal(Philip K. Dick, �Sue�an los androides con ovejas el�ctricas?):"+novedad.getPrecioFinal("Philip K. Dick", "�Sue�an los androides con ovejas el�ctricas?"));
		System.out.println("PrecioFinal(isaac asimov, fundaci�n e imperio):"+novedad.getPrecioFinal("isaac asimov", "fundaci�n e imperio"));
		System.out.println("PrecioFinal(Ray Bradbury, Fahrenheit 451):"+novedad.getPrecioFinal("Ray Bradbury", "Fahrenheit 451"));
		System.out.println("PrecioFinal(Aldous Huxley, Un Mundo Feliz):"+novedad.getPrecioFinal("Aldous Huxley", "Un Mundo Feliz"));
		System.out.println("PrecioFinal(Isaac Asimov, La Fundaci�n):"+novedad.getPrecioFinal("Isaac Asimov", "La Fundaci�n"));
		System.out.println("PrecioFinal(william gibson, neuromante):"+novedad.getPrecioFinal("william gibson", "neuromante"));
		System.out.println("PrecioFinal(Isaac Asimov, Segunda Fundaci�n):"+novedad.getPrecioFinal("Isaac Asimov", "Segunda Fundaci�n"));
		System.out.println("PrecioFinal(Isaac Newton, Arithmetica Universalis):"+novedad.getPrecioFinal("Isaac Newton", "Arithmetica Universalis"));
		
		
	}

}
