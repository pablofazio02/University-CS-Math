boolean p;
if (exists p , p) 
   print(1);
if (exists p , !p) 
   print(2);
if (exists p , p && !p) {
   print(3);
}
print(0);

