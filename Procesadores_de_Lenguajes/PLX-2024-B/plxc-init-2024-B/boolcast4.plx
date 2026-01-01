boolean alfa,beta;
int x,y;
int i;
i=0;
x=12; 
y=15;
for(i=0; i<x; i=i+1){
    alfa = (boolean) (i*i);
    beta = (boolean) (i-1);
    y = y + (int) (boolean) i * i - (int) (boolean) i - 1;
}
print(y);
if (alfa) print(x); else print(y-x);
