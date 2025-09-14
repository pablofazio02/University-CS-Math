function [difW, difT] = retropropagacionError(patron, Z, y, w, s, h, u, Beta, eta)
%% Función que calcula los diferenciales de los pesos W y T

    %% Incialización de variables
    nSalidas=size(y,1);
    nOcultas=size(w,2);
    
    delta2=zeros(nSalidas,1);
    difW=zeros(nSalidas, nOcultas);
    delta1=zeros(nOcultas,1);
    difT=zeros(nOcultas,size(patron,2));
    
    %% --> Cálculo de deltas2 y difW <--
    
    %% Aquí hay un par de erratas con las dimensiones
    %% difW tiene que ser de size (numSalidas x numOcultas)
    %% difT tiene que ser de size (numOcultas x numEntradas)
    
    err = (Z-y);
    g1d = derivadaLogistica(h,Beta);
    g2d = derivadaLogistica(u,Beta);
    deltas2 = err*g1d;
    difW = eta*deltas2*s; % Diapositiva 21 - Sesión I
    
    %% --> Cálculo de deltas1 y difT <--
    deltas1 = g2d*deltas2*w;
    difT = eta*deltas1*patron'; % Diapositiva 22 y 23 - Sesión I
end

