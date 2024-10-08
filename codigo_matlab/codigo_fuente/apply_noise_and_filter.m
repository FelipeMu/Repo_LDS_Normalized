function apply_noise_and_filter(struct_signals, sampling_freq, len_signals_noises)
    
    % Carpeta donde se guardaran los nuevos archivos CSV con ruido
    output_folder = 'D:/TT/Memoria/waveletycnn/codigo_matlab/codigo_fuente/signals_noises';
    if ~exist(output_folder, 'dir')
        mkdir(output_folder);
    end
    

    % Parametros de ruido gaussiano
    cv_inf = 0.05;
    cv_sup = 0.01;
    % Parametros del filtro Butterworth
    order = 8;  % Octavo orden
    nyquist = sampling_freq / 2;  % Frecuencia de Nyquist
    cutoff_freq = 0.25 * nyquist;  % Frecuencia de corte real en Hz
    [b, a] = butter(order, cutoff_freq / nyquist, 'low');  % Coeficientes del filtro
    
    % Recorrer cada archivo CSV en la estructura struct_signals
    num_signals = numel(struct_signals);
    for idx = 1:num_signals
        % Se recoge la senal PAM y VSC del sujeto i
        original_signal_pam = struct_signals(idx).signal_pam; % Senal original PAM
        original_signal_vsc = struct_signals(idx).signal_vsc; % Senal original VSC
    
        % Crear 50 senales con ruido hemodinamico y aplicar el filtro para
        % PAM y VSC
        for i = 1:len_signals_noises
            % Generar coeficiente de variacion aleatorio entre 5% y 10%
            cv = (cv_inf + (cv_sup - cv_inf) * rand());  % Coeficiente de variacion en porcentaje
            
            % Calcular desviacion estandar del ruido basado en la media de la senal original
            noise_std_pam = mean(original_signal_pam) * cv;
            noise_std_vsc = mean(original_signal_vsc) * cv;
            
            % Generar ruido blanco gaussiano (GWN)
            noise_pam = noise_std_pam * randn(size(original_signal_pam));
            noise_vsc = noise_std_vsc * randn(size(original_signal_vsc));

            % Agregar el ruido a la senal original
            noisy_signal_pam = original_signal_pam + noise_pam;
            noisy_signal_vsc = original_signal_vsc + noise_vsc;

            % Aplicar el filtro Butterworth pasabajos
            filtered_signal_pam = filtfilt(b, a, noisy_signal_pam);
            filtered_signal_vsc = filtfilt(b, a, noisy_signal_vsc);

            % Crear carpeta para el sujeto i
            [~, name, ~] = fileparts(struct_signals(idx).name_file); % Se obtiene solo el nombre del archivo sin el .csv
            new_file_output_path_i = fullfile(output_folder, name); % se crea carpeta del sujeto i
            % Crear carpeta si no existe
            if ~exist(new_file_output_path_i, 'dir')
                mkdir(new_file_output_path_i);
            end



            % Guardar la nueva senal en un archivo CSV con el nombre del
            % sujeto i, luego el nombre de la senal y la respectiva
            % iteracion
            new_file_name_pam = sprintf('%s_ruidoPAM%d.csv', name, i);
            new_file_name_vsc = sprintf('%s_ruidoVSC%d.csv', name, i);

            % Se guardan los archivos .csv en sus respectivas carpetas (sujeto i)

            % Ahora se debe crear una carpeta para guardar las vsc_noises y
            % otra carpeta para guardar las pam_noises
            
            % Carpeta para PAM noises
            new_file_pam_noises = fullfile(new_file_output_path_i, 'PAMnoises'); % se crea carpeta del sujeto i
            % Crear carpeta si no existe
            if ~exist(new_file_pam_noises, 'dir')
                mkdir(new_file_pam_noises);
            end


            % Carpeta para VSC noises
            new_file_vsc_noises = fullfile(new_file_output_path_i, 'VSCnoises'); % se crea carpeta del sujeto i
            % Crear carpeta si no existe
            if ~exist(new_file_vsc_noises, 'dir')
                mkdir(new_file_vsc_noises);
            end


            % Se guardan los archivos .csv en sus respectivas carpetas de
            % ruido VSC y PAM
            output_path_pam = fullfile(new_file_pam_noises, new_file_name_pam);
            output_path_vsc = fullfile(new_file_vsc_noises, new_file_name_vsc);
            
            % Guardar la senal en el archivo CSV
            writematrix(filtered_signal_pam, output_path_pam);
            writematrix(filtered_signal_vsc, output_path_vsc);
        end
    end
end