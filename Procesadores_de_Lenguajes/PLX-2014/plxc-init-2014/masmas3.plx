int x;
x=1;
// (x)++ es correcto, pero (x+x)++ es incorrecto
x = 1 + (x)++ + (x+x)++ ; 
print (x);
