boolean p,q;
if (exists p , exists q, p <--> q <--> p) 
   print(1);
if (exists p , exists q, p <--> p <--> q) 
   print(2);
if (exists q , exists p, !(p <--> p) <--> q) 
   print(3);
print(4);

