function [struct_lds_sano_norm, struct_lds_tec_norm] = apply_noise_and_filter_lds(struct_lds_sano_norm, struct_lds_tec_norm, sampling_freq, len_signals_noises)
    
    % Carpeta donde se guardaran los nuevos archivos CSV con ruido (generar  D:\TT\Memoria\waveletycnn\codigo_matlab\codigo_fuente\signals_LDS\SANOS
    output_folder_sanos = 'D:/TT/Memoria/CodigoFuenteNormalized/codigo_matlab/codigo_fuente/signals_LDS_Norm/SANOS';
    output_folder_tec = 'D:/TT/Memoria/CodigoFuenteNormalized/codigo_matlab/codigo_fuente/signals_LDS_Norm/TEC';

    % Parametros de ruido gaussiano
    cv_inf = 0;
    cv_sup = 0.05;
    % Parametros del filtro Butterworth
    order = 8;  % Octavo orden
    nyquist = sampling_freq / 2;  % Frecuencia de Nyquist
    cutoff_freq = 0.25;  % Frecuencia de corte real en Hz
    [b, a] = butter(order, cutoff_freq / nyquist, 'low');  % Coeficientes del filtro
    


    %============================================
    %=============== SANOS & TEC ================
    %============================================

    % Recorrer cada archivo CSV en la estructura struct_dls_sano
    num_signals_sanos = numel(struct_lds_sano_norm);
    for idx = 1:num_signals_sanos
        % Se recoge la senal PAM y VSCd y VSCi del sujeto SANO idx (idx: 1...27)
        original_signal_pam_sano = struct_lds_sano_norm(idx).signal_pam; % Senal original PAM sano
        original_signal_vscd_sano = struct_lds_sano_norm(idx).signal_vscd; % Senal original VSCd sano
        original_signal_vsci_sano = struct_lds_sano_norm(idx).signal_vsci; % Senal original VSCd sano
        % Se recoge la senal PAM y VSCd y VSCi del sujeto TEC idx (idx: 1...27)
        original_signal_pam_tec = struct_lds_tec_norm(idx).signal_pam; % Senal original PAM tec
        original_signal_vscd_tec = struct_lds_tec_norm(idx).signal_vscd; % Senal original VSCd tec
        original_signal_vsci_tec = struct_lds_tec_norm(idx).signal_vsci; % Senal original VSCd tec
    
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%% NORMALIZACION MIN-MAX %%%%%%% SUJETO SANO %%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % NORMALIZACION DE SENALES ORIGNALES Y GUARDADO DE SUS MIN Y
        % MAX:
        % ORIGINAL PAM:
        [minPAM, maxPAM, normPAM] = norm_min_max_original_signal(original_signal_pam_sano);
        struct_lds_sano_norm(idx).signal_pam_min = minPAM;
        struct_lds_sano_norm(idx).signal_pam_max = maxPAM;
        struct_lds_sano_norm(idx).signal_pam_norm = normPAM;
        % ORIGINAL VSCd:
        [minVSCd, maxVSCd, normVSCd] = norm_min_max_original_signal(original_signal_vscd_sano);
        struct_lds_sano_norm(idx).signal_vscd_min = minVSCd;
        struct_lds_sano_norm(idx).signal_vscd_max = maxVSCd;
        struct_lds_sano_norm(idx).signal_vscd_norm = normVSCd;
        % ORIGINAL VSCI:
        [minVSCi, maxVSCi, normVSCi] = norm_min_max_original_signal(original_signal_vsci_sano);
        struct_lds_sano_norm(idx).signal_vsci_min = minVSCi;
        struct_lds_sano_norm(idx).signal_vsci_max = maxVSCi;
        struct_lds_sano_norm(idx).signal_vsci_norm = normVSCi;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%% NORMALIZACION MIN-MAX %%%%%% PACIENTE TEC %%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        % NORMALIZACION DE SENALES ORIGNALES Y GUARDADO DE SUS MIN Y
        % MAX:
        % ORIGINAL PAM:
        [minPAM, maxPAM, normPAM] = norm_min_max_original_signal(original_signal_pam_tec);
        struct_lds_tec_norm(idx).signal_pam_min = minPAM;
        struct_lds_tec_norm(idx).signal_pam_max = maxPAM;
        struct_lds_tec_norm(idx).signal_pam_norm = normPAM;
        % ORIGINAL VSCd:
        [minVSCd, maxVSCd, normVSCd] = norm_min_max_original_signal(original_signal_vscd_tec);
        struct_lds_tec_norm(idx).signal_vscd_min = minVSCd;
        struct_lds_tec_norm(idx).signal_vscd_max = maxVSCd;
        struct_lds_tec_norm(idx).signal_vscd_norm = normVSCd;
        % ORIGINAL VSCI:
        [minVSCi, maxVSCi, normVSCi] = norm_min_max_original_signal(original_signal_vsci_tec);
        struct_lds_tec_norm(idx).signal_vsci_min = minVSCi;
        struct_lds_tec_norm(idx).signal_vsci_max = maxVSCi;
        struct_lds_tec_norm(idx).signal_vsci_norm = normVSCi;
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


        % Crear 50 senales con ruido hemodinamico y aplicar el filtro para
        % PAM - VSCd - VSCi
        for i = 1:len_signals_noises
            % Generar coeficiente de variacion aleatorio entre 5% y 10%
            cv = (cv_inf + (cv_sup - cv_inf) * rand());  % Coeficiente de variacion en porcentaje
            
            % Calcular desviacion estandar del ruido basado en la media de
            % la senal original - sujeto sano
            noise_std_pam_sano = mean(original_signal_pam_sano) * cv; %PAM sano 
            noise_std_vscd_sano = mean(original_signal_vscd_sano) * cv; %VSCd sano
            noise_std_vsci_sano = mean(original_signal_vsci_sano) * cv; %VSCi sano
            % Calcular desviacion estandar del ruido basado en la media de
            % la senal original - sujeto tec
            noise_std_pam_tec = mean(original_signal_pam_tec) * cv; %PAM tec
            noise_std_vscd_tec = mean(original_signal_vscd_tec) * cv; %VSCd tec
            noise_std_vsci_tec = mean(original_signal_vsci_tec) * cv; %VSCi tec


            
            % Generar ruido blanco gaussiano (GWN) - sujeto sano
            noise_pam_sano = noise_std_pam_sano * randn(size(original_signal_pam_sano));%SANO
            noise_vscd_sano = noise_std_vscd_sano * randn(size(original_signal_vscd_sano));%SANO
            noise_vsci_sano = noise_std_vsci_sano * randn(size(original_signal_vsci_sano));%SANO
            % Generar ruido blanco gaussiano (GWN) - sujeto tec
            noise_pam_tec = noise_std_pam_tec * randn(size(original_signal_pam_tec));%TEC
            noise_vscd_tec = noise_std_vscd_tec * randn(size(original_signal_vscd_tec));%TEC
            noise_vsci_tec = noise_std_vsci_tec * randn(size(original_signal_vsci_tec));%TEC

            % Agregar el ruido a la senal original - sujeto sano
            noisy_signal_pam_sano = original_signal_pam_sano + noise_pam_sano;%SANO
            noisy_signal_vscd_sano = original_signal_vscd_sano + noise_vscd_sano;%SANO
            noisy_signal_vsci_sano = original_signal_vsci_sano + noise_vsci_sano;%SANO
            % Agregar el ruido a la senal original - sujeto tec
            noisy_signal_pam_tec = original_signal_pam_tec + noise_pam_tec;%TEC
            noisy_signal_vscd_tec = original_signal_vscd_tec + noise_vscd_tec;%TEC
            noisy_signal_vsci_tec = original_signal_vsci_tec + noise_vsci_tec;%TEC

            % Aplicar el filtro Butterworth pasabajos - sujeto sano
            filtered_signal_pam_sano = filtfilt(b, a, noisy_signal_pam_sano);%SANO
            filtered_signal_vscd_sano = filtfilt(b, a, noisy_signal_vscd_sano);%SANO
            filtered_signal_vsci_sano = filtfilt(b, a, noisy_signal_vsci_sano);%SANO
            % Aplicar el filtro Butterworth pasabajos - sujeto tec
            filtered_signal_pam_tec = filtfilt(b, a, noisy_signal_pam_tec);%TEC
            filtered_signal_vscd_tec = filtfilt(b, a, noisy_signal_vscd_tec);%TEC
            filtered_signal_vsci_tec = filtfilt(b, a, noisy_signal_vsci_tec);%TEC

 
            % NORMALIZACION min-max para senales con ruido PAM, VSCd y VSCd
            % - sujeto sano // se guardan los min y max de las senales con
            % ruido en la respectiva estructura de sujeto sano
            [signal_pam_noise_norm_sano_1, struct_lds_sano_norm] = norm_min_max(struct_lds_sano_norm, idx,  i, filtered_signal_pam_sano, 'pam');% Norm PAM - SANO  
            [signal_pam_noise_norm_sano_2, struct_lds_sano_norm] = norm_min_max(struct_lds_sano_norm, idx, i, filtered_signal_pam_sano, 'pam');% Norm PAM - SANO  
            [signal_vscd_noise_norm_sano, struct_lds_sano_norm] = norm_min_max(struct_lds_sano_norm, idx, i, filtered_signal_vscd_sano, 'vscd');% Norm VSCd - SANO    
            [signal_vsci_noise_norm_sano, struct_lds_sano_norm] = norm_min_max(struct_lds_sano_norm, idx, i, filtered_signal_vsci_sano, 'vsci');% Norm VSCi - SANO
            % NORMALIZACION min-max para senales con ruido PAM, VSCd y VSCd
            % - sujeto tec  // // se guardan los min y max de las senales con
            % ruido en la respectiva estructura de sujeto tec
            [signal_pam_noise_norm_tec_1, struct_lds_tec_norm] = norm_min_max(struct_lds_tec_norm, idx,  i, filtered_signal_pam_tec, 'pam');% Norm PAM - TEC  
            [signal_pam_noise_norm_tec_2, struct_lds_tec_norm] = norm_min_max(struct_lds_tec_norm, idx,  i, filtered_signal_pam_tec, 'pam');% Norm PAM - TEC  
            [signal_vscd_noise_norm_tec, struct_lds_tec_norm] = norm_min_max(struct_lds_tec_norm, idx,  i, filtered_signal_vscd_tec, 'vscd');% Norm VSCd - TEC    
            [signal_vsci_noise_norm_tec, struct_lds_tec_norm] = norm_min_max(struct_lds_tec_norm, idx,  i, filtered_signal_vsci_tec, 'vsci');% Norm VSCi - TEC
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Crear carpeta para el sujeto sano idx
            [~, name_sano, ~] = fileparts(struct_lds_sano_norm(idx).name_file); % Se obtiene solo el nombre de la carpeta del sujeto analizado (ej: 1_HEMU)
            path_sano_idx = fullfile(output_folder_sanos, name_sano); % Se obtiene el directorio de la carpeta del sujeto sano idx
            % Crear carpeta para el sujeto tec idx
            [~, name_tec, ~] = fileparts(struct_lds_tec_norm(idx).name_file); % Se obtiene solo el nombre de la carpeta del sujeto analizado (ej: 1_DENI1005)
            path_tec_idx = fullfile(output_folder_tec, name_tec); % Se obtiene el directorio de la carpeta del sujeto sano idx
            
       
            % Guardar la nueva senal en un archivo CSV con el nombre del
            % sujeto sano idx, luego el nombre de la senal y la respectiva
            % iteracion
            new_file_name_pam_sano = sprintf('%s_ruidoPAM%d.csv', name_sano, i);%SANO
            new_file_name_vscd_sano = sprintf('%s_ruidoVSCd%d.csv', name_sano, i);%SANO
            new_file_name_vsci_sano = sprintf('%s_ruidoVSCi%d.csv', name_sano, i);%SANO
            % Guardar la nueva senal en un archivo CSV con el nombre del
            % sujeto tec idx, luego el nombre de la senal y la respectiva
            % iteracion
            new_file_name_pam_tec = sprintf('%s_ruidoPAM%d.csv', name_tec, i);%TEC
            new_file_name_vscd_tec = sprintf('%s_ruidoVSCd%d.csv', name_tec, i);%TEC
            new_file_name_vsci_tec = sprintf('%s_ruidoVSCi%d.csv', name_tec, i);%TEC
        

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Ahora se debe crear carpetas para guardar las pam_noises,
            % vscd_noises y vsci_noises - sujeto SANO
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            % Carpeta para PAM noises - SANO
            new_file_pam_noises_sano = fullfile(path_sano_idx, 'PAMnoises'); % se crea carpeta PAM del sujeto idx
            % Crear carpeta si no existe
            if ~exist(new_file_pam_noises_sano, 'dir')
                mkdir(new_file_pam_noises_sano);
            end


            % Carpeta para VSCd noises - SANO
            new_file_vscd_noises_sano = fullfile(path_sano_idx, 'VSCdnoises'); % se crea carpeta VSCd del sujeto idx
            % Crear carpeta si no existe
            if ~exist(new_file_vscd_noises_sano, 'dir')
                mkdir(new_file_vscd_noises_sano);
            end


            % Carpeta para VSCi noises - SANO
            new_file_vsci_noises_sano = fullfile(path_sano_idx, 'VSCinoises'); % se crea carpeta VSCi del sujeto idx
            % Crear carpeta si no existe
            if ~exist(new_file_vsci_noises_sano, 'dir')
                mkdir(new_file_vsci_noises_sano);
            end

             %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Ahora se debe crear carpetas para guardar las pam_noises,
            % vscd_noises y vsci_noises - sujeto TEC
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            
            % Carpeta para PAM noises - TEC
            new_file_pam_noises_tec = fullfile(path_tec_idx, 'PAMnoises'); % se crea carpeta PAM del sujeto idx
            % Crear carpeta si no existe
            if ~exist(new_file_pam_noises_tec, 'dir')
                mkdir(new_file_pam_noises_tec);
            end


            % Carpeta para VSCd noises - TEC
            new_file_vscd_noises_tec = fullfile(path_tec_idx, 'VSCdnoises'); % se crea carpeta VSCd del sujeto idx
            % Crear carpeta si no existe
            if ~exist(new_file_vscd_noises_tec, 'dir')
                mkdir(new_file_vscd_noises_tec);
            end


            % Carpeta para VSCi noises - TEC
            new_file_vsci_noises_tec = fullfile(path_tec_idx, 'VSCinoises'); % se crea carpeta VSCi del sujeto idx
            % Crear carpeta si no existe
            if ~exist(new_file_vsci_noises_tec, 'dir')
                mkdir(new_file_vsci_noises_tec);
            end

            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            % Se guardan los archivos .csv en sus respectivas carpetas de
            % ruido PAM, VSCd Y VSCi: sujetos SANOS & TEC
            %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

            % SANOS
            output_path_pam_sano = fullfile(new_file_pam_noises_sano, new_file_name_pam_sano);%SANO
            output_path_vscd_sano = fullfile(new_file_vscd_noises_sano, new_file_name_vscd_sano);%SANO
            output_path_vsci_sano = fullfile(new_file_vsci_noises_sano, new_file_name_vsci_sano);%SANO
            % TEC
            output_path_pam_tec = fullfile(new_file_pam_noises_tec, new_file_name_pam_tec);%TEC
            output_path_vscd_tec = fullfile(new_file_vscd_noises_tec, new_file_name_vscd_tec);%TEC
            output_path_vsci_tec = fullfile(new_file_vsci_noises_tec, new_file_name_vsci_tec);%TEC
            
            % Guardar la senal en el archivo CSV - SANOS
            writematrix(signal_pam_noise_norm_sano_1, output_path_pam_sano);%SANO
            writematrix(signal_vscd_noise_norm_sano, output_path_vscd_sano);%SANO
            writematrix(signal_vsci_noise_norm_sano, output_path_vsci_sano);%SANO
            % Guardar la senal en el archivo CSV - TEC
            writematrix(signal_pam_noise_norm_tec_1, output_path_pam_tec);%TEC
            writematrix(signal_vscd_noise_norm_tec, output_path_vscd_tec);%TEC
            writematrix(signal_vsci_noise_norm_tec, output_path_vsci_tec);%TEC
        end
    end
end