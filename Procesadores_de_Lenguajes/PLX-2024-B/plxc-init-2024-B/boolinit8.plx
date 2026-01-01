int x=1; 
boolean by, bz;
boolean bx = by = x == 0; 
if(!bx) {
   print(1); 
   if(bx = by = bz = x == 1) { 
      print(2);
   }
   if (by) {
     print(3);
   }
   if (bz) {
     print(4);
   }
}
print(x);
