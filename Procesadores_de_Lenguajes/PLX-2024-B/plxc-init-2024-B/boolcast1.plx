boolean p,q;
p = false;
int x;
x = 2;
p = (boolean) (x*x-x+x);
q = (boolean) (x+x-x*x);
if (p) print(1);
if (q) print(2);
if (p || q) print(3);
print(0);

