program Power(x,y,z);

// A simple WHILE program to compute the power x of y 

x := 17;
y := 5;
z := 1;
while 1 <= y do begin
   z := x * z;
   y := y - 1
end