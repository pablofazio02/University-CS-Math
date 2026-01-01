boolean p;
if (forall p , p) 
   print(1);
if (forall p , !p) 
   print(2);
if (forall p , p || !p) {
   print(3);
}
print(0);

