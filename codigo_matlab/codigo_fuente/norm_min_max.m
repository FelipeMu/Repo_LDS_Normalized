function [normalized, struct] = norm_min_max(struct, idx, i, signal, type)    
    % Aplicacion de normalizacion min-max
    min_sig = min(signal);
    max_sig = max(signal);
    norm_signal = (signal - min_sig) / (max_sig - min_sig);
    normalized = norm_signal; % senal normalizada [0, 1]

    if strcmp(type, 'pam')
        % Se procede a guardar el min y max de la senal PAM con ruido en su
        % estructura en la instancia i
        struct(idx).struct_VSCd_noises(i).min_pam = min_sig;
        struct(idx).struct_VSCd_noises(i).max_pam = max_sig;

        struct(idx).struct_VSCi_noises(i).min_pam = min_sig;
        struct(idx).struct_VSCi_noises(i).max_pam = max_sig;
    elseif strcmp(type, 'vscd')
        % Se procede a guardar el min y max de la senal VSCi con ruido en su
        % estructura en la instancia i
        struct(idx).struct_VSCd_noises(i).min_vscd = min_sig;
        struct(idx).struct_VSCd_noises(i).max_vscd = max_sig;
    elseif strcmp(type, 'vsci')
        % Se procede a guardar el min y max de la senal VSCd con ruido en su
        % estructura en la instancia i
        struct(idx).struct_VSCi_noises(i).min_vsci = min_sig;
        struct(idx).struct_VSCi_noises(i).max_vsci = max_sig;
    else
        disp('tipo de senal a normalizar no encontrada.');
    end
end