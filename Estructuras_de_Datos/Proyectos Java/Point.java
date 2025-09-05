/*
  Estructuras de Datos
  Grado en Ingeniería Informática, del Software y de Computadores
  Tema 3. TAD Lineales
  Pablo López
*/

package referencias;

/**
 * Ejemplo simple de TAD en Java
 */

public class Point {

    /* Representación física oculta del tipo Point */

    private int x;
    private int y;

    public Point(int i, int j) {
        x = i;
        y = j;
    }

    public void move(int dx, int dy) {
        x = x + dx;
        y = y + dy;
    }

    @Override
    public String toString() {
        return "Point(" + x + ", " + y + ")";
    }
}
