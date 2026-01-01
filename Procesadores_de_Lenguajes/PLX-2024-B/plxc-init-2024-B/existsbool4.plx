boolean p,q;
if (exists p, exists q, p && q <--> p || q ) 
   print(1);
if ((exists p, exists q, p && q <--> p || q) && (exists p, p&&!p) )
   print(2);
if (exists p, exists q, p || q <--> p && q )
   print(3);
print(0);

