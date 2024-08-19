function [en] = get_step_normalized(Ts, order, cut_freq)
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
    disp('largoo:');
    disp(length(escalonInversoFinal));
    
    % Obtencion de escalon normalizado: 
    mins = min(escalonInversoFinal);
    maxs = max(escalonInversoFinal);
    en = (escalonInversoFinal - mins)/(maxs - mins); 
end