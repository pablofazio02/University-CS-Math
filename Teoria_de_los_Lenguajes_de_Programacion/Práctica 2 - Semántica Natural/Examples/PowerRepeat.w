program PowerRepeat(x,y,z);

// A simple WHILE program to compute the power x of y 

x := 5;
y := 1;
z := 1;

if y = 0 then
   z := 1
else
   repeat
      z := x * z;
      y := y - 1
   until y = 0