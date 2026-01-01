int x;
if (exists x from 1 to 10, x*x < 0) {
   print(1);
}
if (exists x from 1 to 5, x*x > 10) {
   print(2);
}
print(0);

