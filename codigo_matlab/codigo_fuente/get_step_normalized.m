function [new_step] = get_step_normalized(Ts, order, cut_freq)
    %Ts=0.2;
    %order=2;
    %cut_freq=0.3;
    escalonInverso=ones(150/Ts,1);
    escalonInverso(1:length(escalonInverso)/2)=escalonInverso(1:length(escalonInverso)/2);%*max(PAM);
    escalonInverso(1+length(escalonInverso)/2:length(escalonInverso))=escalonInverso(1+length(escalonInverso)/2:length(escalonInverso))*0;%*min(PAM);
    [b,a] = butter(order,cut_freq);
    escalonInverso = filter(b,a,escalonInverso);
    escalonInverso=[escalonInverso,zeros(length(escalonInverso),1)];
    escalonInverso_cut = escalonInverso(326:end);
    escalonInverso_cut_column = escalonInverso_cut(:); 
    less = abs(1024 - length(escalonInverso_cut_column));
    escalonInversoFinal = escalonInverso_cut_column(1:(end-less));
    %disp('largoo:');
    %disp(length(escalonInversoFinal));
    
    % Obtencion de escalon normalizado: 
    mins = min(escalonInversoFinal);
    maxs = max(escalonInversoFinal);
    en = (escalonInversoFinal - mins)/(maxs - mins); 

    
    % *** NUEVO ESCALON PARA MEJORAR LA ESTABILIZACION LUEGO DEL TRANSCIENTE ***

    % Se procede a modificar el escalon para mejorar el transciente, para
    % ello, se aumenta el largo del escalon cuando y=1, para que antes
    % de la caida logre estabilizarse y el valor min de la respuesta este
    % dentro de los intervalos teoricos.

    % nuevo escalon: se recorta en la instancia 216 = 40 seg
    fin = 266;
    step = en(1:fin); % con esto se tienen 40 segundos luego de la caida de presion
    trozo = 1024-fin;
    add = ones(trozo, 1);
    new_step = [add; step]; % nuevo escalon con un y=1 de 858 instancias (antes eran 50 instancias)

end