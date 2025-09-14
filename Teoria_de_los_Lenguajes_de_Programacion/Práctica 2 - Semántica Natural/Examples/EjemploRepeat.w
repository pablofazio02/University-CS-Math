program EjemploRepeat(x, y);

// A simple WHILE program to see the differences between 'while' and 'repeat until' loops

x:= 5;
y:= 0;

repeat
   y:= x;
   x:= x - 1
until 5 <= y
