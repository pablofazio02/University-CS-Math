int x=12;
int y=15;
int z=20;

boolean p = x<15 && y<20 || z<20; 
boolean q = x<15 && y<15 || z<25;

if (p && q)  
   print(1);
if (p || q)  
   print(2);
if (p && !q)  
   print(3);
if (!p || q)  
   print(4);
 
print(5); 
