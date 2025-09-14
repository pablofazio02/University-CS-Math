function Out=Signo(inp)
Out=sign(inp);
Out(Out==0)=1;

% para los valores negativos, -1 y para los valores positivos y cero,
% devuelve +1
