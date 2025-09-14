program TestParser2(x,y,z);

// a simple, meaningless program to test WhileParser2.y

x := 1;

skip;

if x = 1 then       // simple sentence requires end
   y := 1
else
   y := 2
end;

while x <= 10 do    // simple sentence requires end
   x := x + 1
end;

if !(x = 3) then    // compound sentence requires end
    x := x + 1;
    z := 1
else
    x := x - 1;
    z:= 2
end;

while (x<=10) do    // possible, but ugly
   begin
      x := x * 2;
      y := y - 1
   end
end;

if x = 0 then       // nested ifs
   if y = 1 then
       a := 1;
       z:= 1
   else
     a := 2;
     z := 2
   end
else
   z:= 3
end;

x := 1;
while x <= 5 do    // nested whiles
   x:= x + 1;
   y:= 1;
   while y <= 3 do
      y := y + 2
   end
end;

begin             // nested compound sentences
  begin
     begin
      a := 1
     end
  end
end
