function W=PerceptronWeigthsGenerator(Data)
NInp=size(Data,2); 
W=rand(NInp,1)-0.5;

% size(Data, 2) = te devuelve el número de columnas de Data (K+1)