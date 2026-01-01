boolean p,q;
int i;
while (i<5  && exists p, (p || i/5 < 1) ) {
   print(i);
   i = i+1;
}
while (exists p, exists q, (!p && q) && i>0) {
   p = !p;
   print(i);
   i = i-1;
}
print(0); 
