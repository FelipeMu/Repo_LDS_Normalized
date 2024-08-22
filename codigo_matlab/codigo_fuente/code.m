%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%



% codigo final 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%% PREPROCESAMIENTO DE LAS SENALES: PAM | VSC DERECHA | VSC IZQUIERDA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Se establece la cantidad de senales con ruido que se crearan para el posterior entrenamiento de la red profunda U-NET 
num_of_noises_signals = 15;
num_people = 27;
%=============================
%=== LECTURA DE DLS: SANOS ===
%=============================

% Directorios y configuracion
sourceDirectory_sano = 'D:\TT\Memoria\CodigoFuenteNormalized\codigo_matlab\codigo_fuente\LDS\DATOS_SANOS_PAR';
destinationDirectory_sano = 'D:\TT\Memoria\CodigoFuenteNormalized\codigo_matlab\codigo_fuente\signals_LDS_Norm\SANOS';

% Obtener la lista de archivos .PAR en el directorio
fileList_sano = dir(fullfile(sourceDirectory_sano, '*.PAR'));
num_healthy_people = numel(fileList_sano);

% Inicializar las estructuras
structure_original_PAM(1) = struct('matrix_complex_original_pam', [], 'scalscfs_original_pam', [], 'psif_original_pam', [], 'freqs_original_pam', []);
structure_original_VSCd(1) = struct('matrix_complex_original_vscd', [], 'scalscfs_original_vscd', [], 'psif_original_vscd', [], 'freqs_original_vscd', []);
structure_original_VSCi(1) = struct('matrix_complex_original_vsci', [], 'scalscfs_original_vsci', [], 'psif_original_vsci', [], 'freqs_original_vsci', []);

structure_vscd_noises_sano(1:num_of_noises_signals) = struct('name_file_noise', '', 'pam_noise', [], 'matrix_complex_pam', [], 'scalscfs_pam_noise', [], 'psif_pam_noise', [], 'freqs_pam_noise', [], 'vscd_noise', [], 'matrix_complex_vscd', [], 'scalscfs_vscd_noise', [], 'psif_vscd_noise', [], 'freqs_vscd_noise', [], 'min_pam', 0, 'max_pam', 0, 'min_vscd', 0, 'max_vscd', 0);
structure_vsci_noises_sano(1:num_of_noises_signals) = struct('name_file_noise', '', 'pam_noise', [], 'matrix_complex_pam', [], 'scalscfs_pam_noise', [], 'psif_pam_noise', [], 'freqs_pam_noise', [], 'vsci_noise', [], 'matrix_complex_vsci', [], 'scalscfs_vsci_noise', [], 'psif_vsci_noise', [], 'freqs_vsci_noise', [], 'min_pam', 0, 'max_pam', 0, 'min_vsci', 0, 'max_vsci', 0);
struct_lds_sano_norm(1:num_healthy_people) = struct('name_file', '', 'signal_pam', [], 'signal_pam_norm', [], 'signal_pam_min', 0, 'signal_pam_max', 0, 'signal_vscd', [], 'signal_vscd_norm', [], 'signal_vscd_min', 0, 'signal_vscd_max', 0, 'signal_vsci', [], 'signal_vsci_norm', [], 'signal_vsci_min', 0, 'signal_vsci_max', 0, 'struct_VSCd_noises', structure_vscd_noises_sano, 'struct_VSCi_noises', structure_vsci_noises_sano, 'struct_original_PAM', [], 'struct_original_VSCd', [], 'struct_original_VSCi', []);

temp = 0; % activador para considerar que la senal PAM es la columna 2 (solo para el sujeto 27_HC036101.PAR)
% Recorrer cada archivo
for i = 1:num_healthy_people
    % Obtener nombre del archivo y crear la ruta completa
    filename_sano = fileList_sano(i).name;
    disp(filename_sano);
    filepath_sano = fullfile(sourceDirectory_sano, filename_sano);
    
    % Determinar el delimitador segun el nombre del archivo
    if strcmp(filename_sano, '22_ALSA.PAR')
        delimiter_sano = '\t';
        columnsToRead_sano = 3:5;
    elseif strcmp(filename_sano, '27_HC036101.PAR')
        delimiter_sano = ' ';
        columnsToRead_sano = 3:5;
        temp = 1; % se activa para considerar que la senal PAM es la columna 2 y no la 3 como en el resto de los sujetos sanos
    else
        delimiter_sano = ' ';
        columnsToRead_sano = 4:6;
    end
    
    % Leer el archivo de texto
    data_sano= readmatrix(filepath_sano, 'FileType', 'text', 'Delimiter', delimiter_sano);
    % Extraer las columnas especificas (primeras 1024 filas)
    columnas_sano = data_sano(1:1024, columnsToRead_sano);
    
    % Crear la carpeta para el archivo
    folderName_sano = fullfile(destinationDirectory_sano, erase(filename_sano, '.PAR'));
    if ~exist(folderName_sano, 'dir')
        mkdir(folderName_sano);
    end
    
    % Guardar los datos en la estructura
    struct_lds_sano_norm(i).name_file = erase(filename_sano, '.PAR'); %(nombre del individuo)

    if temp == 1
        struct_lds_sano_norm(i).signal_pam = columnas_sano(:, 2); % PAM es la columna 2 para 27_HC036101
        struct_lds_sano_norm(i).signal_vscd = columnas_sano(:, 1); % VSCd es la columna 1 27_HC036101
        struct_lds_sano_norm(i).signal_vsci = columnas_sano(:, 3); % VSCi es la tercera columna para 27_HC036101
        temp = 0;
    else
        struct_lds_sano_norm(i).signal_pam = columnas_sano(:, 3); % PAM es la columna 3 para los los sanos restantes
        struct_lds_sano_norm(i).signal_vscd = columnas_sano(:, 1); % VSCd es la columna 1 para los sanos restantes
        struct_lds_sano_norm(i).signal_vsci = columnas_sano(:, 2); % VSCi es la columna 2 para los sanos restantes
    end
    % Guardar las señales en archivos CSV dentro de la carpeta correspondiente
    pam_sano_csv_path = fullfile(folderName_sano, 'signal_pam.csv');
    vscd_sano_csv_path = fullfile(folderName_sano, 'signal_vscd.csv');
    vsci_sano_csv_path = fullfile(folderName_sano, 'signal_vsci.csv');
    
    writematrix(struct_lds_sano_norm(i).signal_pam, pam_sano_csv_path);
    writematrix(struct_lds_sano_norm(i).signal_vscd, vscd_sano_csv_path);
    writematrix(struct_lds_sano_norm(i).signal_vsci, vsci_sano_csv_path);
end


%===========================
%=== LECTURA DE DLS: TEC ===
%===========================

% Directorios y configuracion
sourceDirectory_tec = 'D:\TT\Memoria\CodigoFuenteNormalized\codigo_matlab\codigo_fuente\LDS\DATOS_TEC_PAR';
destinationDirectory_tec = 'D:\TT\Memoria\CodigoFuenteNormalized\codigo_matlab\codigo_fuente\signals_LDS_Norm\TEC';

% Obtener la lista de archivos .PAR en el directorio
fileList_tec = dir(fullfile(sourceDirectory_tec, '*.PAR'));
num_tec_people = numel(fileList_tec);

% Inicializar las estructuras
structure_vscd_noises_tec(1:num_of_noises_signals) = struct('pam_noise', [], 'matrix_complex_pam', [], 'scalscfs_pam_noise', [], 'psif_pam_noise', [],  'vscd_noise', [], 'matrix_complex_vscd', [], 'scalscfs_vscd_noise', [], 'psif_vscd_noise', [], 'min_pam', 0, 'max_pam', 0, 'min_vscd', 0, 'max_vscd', 0);
structure_vsci_noises_tec(1:num_of_noises_signals) = struct('pam_noise', [], 'matrix_complex_pam', [], 'scalscfs_pam_noise', [], 'psif_pam_noise', [],  'vsci_noise', [], 'matrix_complex_vsci', [], 'scalscfs_vsci_noise', [], 'psif_vsci_noise', [], 'min_pam', 0, 'max_pam', 0, 'min_vsci', 0, 'max_vsci', 0);
struct_lds_tec_norm(1:num_tec_people) = struct('name_file', '', 'signal_pam', [], 'signal_pam_norm', [], 'signal_pam_min', 0, 'signal_pam_max', 0, 'signal_vscd', [], 'signal_vscd_norm', [], 'signal_vscd_min', 0, 'signal_vscd_max', 0, 'signal_vsci', [], 'signal_vsci_norm', [], 'signal_vsci_min', 0, 'signal_vsci_max', 0, 'struct_VSCd_noises', structure_vscd_noises_tec, 'struct_VSCi_noises', structure_vsci_noises_tec, 'struct_original_PAM', [], 'struct_original_VSCd', [], 'struct_original_VSCi', []);

temp = 0; % activador para considerar que la senal que el archivo 6_HASTI007 tiene como delimitador un '\t' y no un ' ' como los otros archivos
% Recorrer cada archivo
for i = 1:num_people
    % Obtener nombre del archivo y crear la ruta completa
    filename_tec = fileList_tec(i).name;
    disp(filename_tec);
    filepath_tec = fullfile(sourceDirectory_tec, filename_tec);
    
    % Determinar el delimitador segun el nombre del archivo
    if strcmp(filename_tec, '6_HASTI007.PAR')
        delimiter_tec = '\t';
        columnsToRead_tec = 1:3;
    else
        delimiter_tec = ' ';
        columnsToRead_tec = 3:5;
        
    end
    % Leer el archivo de texto
    data_tec = readmatrix(filepath_tec, 'FileType', 'text', 'Delimiter', delimiter_tec);
    % Extraer las columnas especificas (primeras 1024 filas)
    columnas_tec = data_tec(1:1024, columnsToRead_tec);
    
    % Crear la carpeta para el archivo
    folderName_tec = fullfile(destinationDirectory_tec, erase(filename_tec, '.PAR'));
    if ~exist(folderName_tec, 'dir')
        mkdir(folderName_tec);
    end
    
    % Guardar los datos en la estructura
    struct_lds_tec_norm(i).name_file = erase(filename_tec, '.PAR');

    % se guardan columnas especificas en la respectiva estructura del
    % paciente:
    struct_lds_tec_norm(i).signal_pam = columnas_tec(:, 2); % PAM: 2 columna
    struct_lds_tec_norm(i).signal_vscd = columnas_tec(:, 1); % VSCd derecho (chanel 1): columna 1
    struct_lds_tec_norm(i).signal_vsci = columnas_tec(:, 3); % VSCi izquierdo (chanel 2): columna 3

    % Guardar las señales en archivos CSV dentro de la carpeta correspondiente
    pam_tec_csv_path = fullfile(folderName_tec, 'signal_pam.csv');
    vscd_tec_csv_path = fullfile(folderName_tec, 'signal_vscd.csv');
    vsci_tec_csv_path = fullfile(folderName_tec, 'signal_vsci.csv');
    
    writematrix(struct_lds_tec_norm(i).signal_pam, pam_tec_csv_path);
    writematrix(struct_lds_tec_norm(i).signal_vscd, vscd_tec_csv_path);
    writematrix(struct_lds_tec_norm(i).signal_vsci, vsci_tec_csv_path);
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%% APLICACIÓN DE RUIDO GAUSSIANO: PAM | VSC DERECHA | VSC IZQUIERDA %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Periodo de muestreo
ts = 0.2; % segundos
% Frecuencia de muestreo
fs = 1.0 / ts; % Hz
% Aplicacion de ruido gaussinano y filtro octavo orden a las senales PAM,
% VSCd y VSCi tanto de sujetos sanos como de pacientes TEC:
[struct_lds_sano_norm, struct_lds_tec_norm] = apply_noise_and_filter_lds(struct_lds_sano_norm, struct_lds_tec_norm, fs, num_of_noises_signals);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%% APLICACIÓN DE CWT Y OBTENCIÓN DE COEFICIENTES: PAM | VSC DERECHA | VSC IZQUIERDA %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%                                                   SUJETO SANO
%===============================================================================================================================
% Se obtienen los nombres de todas las carpetas existentes en el direccion
% path_sano: 27 sujetos en total
path_sano = 'D:/TT/Memoria/CodigoFuenteNormalized/codigo_matlab/codigo_fuente/signals_LDS_Norm/SANOS';
% Obtener los nombres de las carpetas dentro del directorio
folder_structs_sano = dir(path_sano);
folder_names_sano = {folder_structs_sano([folder_structs_sano.isdir]).name}; % se obtiene los nombres de las carpetas
% Eliminar los nombres '.' y '..' que representan el directorio actual y el directorio padre
folder_names_sano = setdiff(folder_names_sano, {'.', '..'}); % vector fila que almcena los nombres de todas las carpetas de sujetos sanos

% Se obtienen los nombres de todas las carpetas existentes en el direccion
% path_files_signals. Carpetas a seleccionar --> PAMnoises, VSCdnoises,
% VSCinoises
path_files_signals_sano = 'D:/TT/Memoria/CodigoFuenteNormalized/codigo_matlab/codigo_fuente/signals_LDS_Norm/SANOS/1_HEMU'; % Se elige 1_HEMU al azar, todos los sujetos tienen las mismas carpetas asociadas a las senales con ruido
% Obtener los nombres de las carpetas dentro del directorio
folder_signals_sano = dir(path_files_signals_sano);
folder_names_signals_sano = {folder_signals_sano([folder_signals_sano.isdir]).name}; % se obtiene los nombres de las carpetas
% Eliminar los nombres '.' y '..' que representan el directorio actual y el directorio padre
folder_names_signals_sano = setdiff(folder_names_signals_sano, {'.', '..'}); % vector fila que almcena los nombres de todas las carpetas de sujetos sanos
%===============================================================================================================================



%                                                   PACIENTE TEC
%===============================================================================================================================
% Se obtienen los nombres de todas las carpetas existentes en el direccion
% path_sano: 27 sujetos en total
path_tec = 'D:/TT/Memoria/CodigoFuenteNormalized/codigo_matlab/codigo_fuente/signals_LDS_Norm/TEC';
% Obtener los nombres de las carpetas dentro del directorio
folder_structs_tec = dir(path_tec);
folder_names_tec = {folder_structs_tec([folder_structs_tec.isdir]).name}; % se obtiene los nombres de las carpetas
% Eliminar los nombres '.' y '..' que representan el directorio actual y el directorio padre
folder_names_tec = setdiff(folder_names_tec, {'.', '..'}); % vector fila que almcena los nombres de todas las carpetas de sujetos sanos

% Se obtienen los nombres de todas las carpetas existentes en el direccion
% path_files_signals. Carpetas a seleccionar --> PAMnoises, VSCdnoises,
% VSCinoises
path_files_signals_tec = 'D:/TT/Memoria/CodigoFuenteNormalized/codigo_matlab/codigo_fuente/signals_LDS_Norm/TEC/1_DENI1005'; % Se elige 1_DENI1005 al azar, todos los sujetos tienen las mismas carpetas asociadas a las senales con ruido
% Obtener los nombres de las carpetas dentro del directorio
folder_signals_tec = dir(path_files_signals_tec);
folder_names_signals_tec = {folder_signals_tec([folder_signals_tec.isdir]).name}; % se obtiene los nombres de las carpetas
% Eliminar los nombres '.' y '..' que representan el directorio actual y el directorio padre
folder_names_signals_tec = setdiff(folder_names_signals_tec, {'.', '..'}); % vector fila que almcena los nombres de todas las carpetas de sujetos sanos
%===============================================================================================================================


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%% PARA SUJETOS SANOS Y PACIENTES TEC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
for index = 1:num_people
    %=========================================================================================================================
    % PARA SUJETO SANO
    % ************* se tiene el nombre de la carpeta: 10_MIMO ************* index=1
    file_person_sano = folder_names_sano(index); %SANO
    % directorio: carpeta del sujeto por analizar
    file_pam_sano = fullfile(path_sano, file_person_sano); %SANO
    %=========================================================================================================================
    % PARA PACIENTE TEC
    % ************* se tiene el nombre de la carpeta:  ************* index=1
    file_person_tec = folder_names_tec(index); %TEC
    % directorio: carpeta del sujeto por analizar
    file_pam_tec = fullfile(path_tec, file_person_tec); %TEC 


    %=========================================================================================================================
    % PARA SUJETO SANO
    % Por cada sujeto se accede a sus carpetas de PAMnoises, VSCdnoises y
    % VSCinoises (se obtienen los path de las carpetas). Ademas se obtienen
    % los archivos .csv existentes en cada una de estas carpetas:
    

 
    % Buscar el indice del nombre de la carpeta en folder_names_signals_sano
    indice_carpeta_pam = find(strcmp(folder_names_signals_sano, 'PAMnoises'));
    % Se obtiene el directorio de la carpeta que almacena las senales PAM con
    % ruido del sujeto index:
    path_pam_noises_sano = fullfile(file_pam_sano{1}, folder_names_signals_sano{indice_carpeta_pam}); % directorio de PAMnoises
 
    % Buscar el indice del nombre de la carpeta en folder_names_signals_sano
    indice_carpeta_vscd = find(strcmp(folder_names_signals_sano, 'VSCdnoises'));
    % Se obtiene el directorio de la carpeta que almacena las senales VSCd con
    % ruido:
    path_vscd_noises_sano = fullfile(file_pam_sano{1}, folder_names_signals_sano{indice_carpeta_vscd}); % directorio de VSCdnoises
 
    % Buscar el indice del nombre de la carpeta en folder_names_signals_sano
    indice_carpeta_vsci = find(strcmp(folder_names_signals_sano, 'VSCinoises'));
    % Se obtiene el directorio de la carpeta que almacena las senales VSCd con
    % ruido:
    path_vsci_noises_sano = fullfile(file_pam_sano{1}, folder_names_signals_sano{indice_carpeta_vsci}); % directorio de VSCinoises
    %=========================================================================================================================
    % PARA PACIENTE TEC
    % Por cada paciente se accede a sus carpetas de PAMnoises, VSCdnoises y
    % VSCinoises (se obtienen los path de las carpetas). Ademas se obtienen
    % los archivos .csv existentes en cada una de estas carpetas:
    
    % Buscar el indice del nombre de la carpeta en folder_names_signals_sano
    indice_carpeta_pam = find(strcmp(folder_names_signals_tec, 'PAMnoises'));
    % Se obtiene el directorio de la carpeta que almacena las senales PAM con
    % ruido del sujeto index:
    path_pam_noises_tec = fullfile(file_pam_tec{1}, folder_names_signals_tec{indice_carpeta_pam}); % directorio de PAMnoises
 
    % Buscar el indice del nombre de la carpeta en folder_names_signals_sano
    indice_carpeta_vscd = find(strcmp(folder_names_signals_tec, 'VSCdnoises'));
    % Se obtiene el directorio de la carpeta que almacena las senales VSCd con
    % ruido:
    path_vscd_noises_tec = fullfile(file_pam_tec{1}, folder_names_signals_tec{indice_carpeta_vscd}); % directorio de VSCdnoises
 
    % Buscar el indice del nombre de la carpeta en folder_names_signals_sano
    indice_carpeta_vsci = find(strcmp(folder_names_signals_tec, 'VSCinoises'));
    % Se obtiene el directorio de la carpeta que almacena las senales VSCd con
    % ruido:
    path_vsci_noises_tec = fullfile(file_pam_tec{1}, folder_names_signals_tec{indice_carpeta_vsci}); % directorio de VSCinoises


    %=========================================================================================================================
    % PARA SUJETO SANO
    % Ahora se deben extraer todos los archivos .csv del directorio
    % path_pam_noises:
    
    % Obtener lista de archivos CSV en la carpeta de PAMnoises
    pam_noises_csv_sano = dir(fullfile(path_pam_noises_sano, '*.csv'));
    
    % Obtener lista de archivos CSV en la carpeta de VSCnoises
    vscd_noises_csvd_sano = dir(fullfile(path_vscd_noises_sano, '*.csv'));
    
    % Obtener lista de archivos CSV en la carpeta de VSCnoises
    vsci_noises_csvi_sano = dir(fullfile(path_vsci_noises_sano, '*.csv'));
    

    % Cantidad de csvs encontrados en el directorio path_pam_noises (total esperado: 50 )
    num_csv = numel(pam_noises_csv_sano); % Se almacena la cantidad de archivos csv leidos
    disp('Cantidad de senales con ruido encontradas:');
    disp(num_csv);
    %=========================================================================================================================
     % PARA PACIENTE TEC
    % Ahora se deben extraer todos los archivos .csv del directorio
    % path_pam_noises:
    
    % Obtener lista de archivos CSV en la carpeta de PAMnoises
    pam_noises_csv_tec = dir(fullfile(path_pam_noises_tec, '*.csv'));
    
    % Obtener lista de archivos CSV en la carpeta de VSCnoises
    vscd_noises_csvd_tec = dir(fullfile(path_vscd_noises_tec, '*.csv'));
    
    % Obtener lista de archivos CSV en la carpeta de VSCnoises
    vsci_noises_csvi_tec = dir(fullfile(path_vsci_noises_tec, '*.csv'));
    %=========================================================================================================================

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%% RELLENADO DE ESTRUCTURAS SANOS Y TEC CON DATOS DE PAM, VSCd Y VSCi CON RUIDO %%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    fprintf("[%i] Pareo sano y tec:\n", index);
    fprintf("%s <-> %s\n",file_person_sano{1}, file_person_tec{1});
    for j = 1:num_csv
        %%%%%%%%%%%%%%%%%%%%%%%%
        %%%%% SUJETO SANO %%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%
        %==========================================================================================================================================
        name_csv_pam_sano = pam_noises_csv_sano(j).name; % Nombre del archivo.csv PAMnoises
        name_csv_vscd_sano = vscd_noises_csvd_sano(j).name; % Nombre del archivo.csv VSCdnoises
        name_csv_vsci_sano = vsci_noises_csvi_sano(j).name; % Nombre del archivo.csv VSCinoises
        % Verificar tripleta de datos vinculados (ej: 10_MIMO_ruidoPAM1.csv | 10_MIMO_ruidoVSCd1.csv | 10_MIMO_ruidoVSCi1.csv)
        %fprintf("%s | %s | %s", name_csv_pam_sano, name_csv_vscd_sano, name_csv_vsci_sano); 
    
        path_pam_noises_sanos = fullfile(path_pam_noises_sano, name_csv_pam_sano); % Ruta completa de la carpeta PAMnoises
        path_vscd_noises_sanos = fullfile(path_vscd_noises_sano, name_csv_vscd_sano); % Ruta completa de la carpeta VSCdnoises
        path_vsci_noises_sanos = fullfile(path_vsci_noises_sano, name_csv_vsci_sano); % Ruta completa de la carpeta VSCinoises


        % Leer el contenido del archivo CSV en carpeta PAMnoises
        data_pam_noises_sanos = readmatrix(path_pam_noises_sanos);
        % Leer el contenido del archivo CSV en la carpeta VSCdnoises
        data_vscd_noises_sanos = readmatrix(path_vscd_noises_sanos);
        % Leer el contenido del archivo CSV en la carpeta VSCinoises
        data_vsci_noises_sanos = readmatrix(path_vsci_noises_sanos); 

        % Asignar a la estructura
        struct_lds_sano_norm(index).struct_VSCd_noises(j).name_file_noise = ['Ruido', num2str(j)]; % Guardar el nombre del archivo
        % Lado derecho cerebro
        struct_lds_sano_norm(index).struct_VSCd_noises(j).pam_noise = data_pam_noises_sanos; % Guardar la senal PAM con ruido
        struct_lds_sano_norm(index).struct_VSCd_noises(j).vscd_noise = data_vscd_noises_sanos; % Guardar la senal VSCd con ruido
        % Lado izquierdo cerebro
        struct_lds_sano_norm(index).struct_VSCi_noises(j).pam_noise = data_pam_noises_sanos; % Guardar la senal PAM con ruido
        struct_lds_sano_norm(index).struct_VSCi_noises(j).vsci_noise = data_vsci_noises_sanos; % Guardar la senal VSCi con ruido


        %########################################
        %######## Aplicacion de CWT #############
        %########################################
    
        % WAVELET MADRE CONTINUA A UTILIZAR: Analytic Morlet (Gabor)
        % Wavelet:amor
        
        % [PAM NOISE - CWT]
        [coefs_pam_noise, freqs_pam_noise, scalcfs_pam_noise, psif_pam_noise] = cwt(struct_lds_sano_norm(index).struct_VSCd_noises(j).pam_noise);
        % [VSC NOISE - CWT]
        [coefs_vscd_noise, freqs_vscd_noise, scalcfs_vscd_noise, psif_vscd_noise] = cwt(struct_lds_sano_norm(index).struct_VSCd_noises(j).vscd_noise);
        % [VSC NOISE - CWT]
        [coefs_vsci_noise, freqs_vsci_noise, scalcfs_vsci_noise, psif_vsci_noise] = cwt(struct_lds_sano_norm(index).struct_VSCi_noises(j).vsci_noise);

        % Almacenando nueva informacion en la respectiva estructura de senales
        % con ruido:
        
        % Almacenando coeficientes (matriz compleja)
        struct_lds_sano_norm(index).struct_VSCd_noises(j).matrix_complex_pam = coefs_pam_noise; % PAM lado derecho
        struct_lds_sano_norm(index).struct_VSCi_noises(j).matrix_complex_pam = coefs_pam_noise; % PAM lado izquierdo
        struct_lds_sano_norm(index).struct_VSCd_noises(j).matrix_complex_vscd = coefs_vscd_noise; % VSCd
        struct_lds_sano_norm(index).struct_VSCi_noises(j).matrix_complex_vsci = coefs_vsci_noise; % VSCi
    
        % Almacenando escalas de coeficientes (vector fila 1D real , largo 1024)
        struct_lds_sano_norm(index).struct_VSCd_noises(j).scalscfs_pam_noise = scalcfs_pam_noise; % PAM lado derecho
        struct_lds_sano_norm(index).struct_VSCi_noises(j).scalscfs_pam_noise = scalcfs_pam_noise; % PAM lado derecho
        struct_lds_sano_norm(index).struct_VSCd_noises(j).scalscfs_vscd_noise = scalcfs_vscd_noise; % VSCd
        struct_lds_sano_norm(index).struct_VSCi_noises(j).scalscfs_vsci_noise = scalcfs_vsci_noise; % VSCd
    
        % Almacenando respuestas de filtros (matriz real 30x1024)
        struct_lds_sano_norm(index).struct_VSCd_noises(j).psif_pam_noise = psif_pam_noise; % PAM lado derecho
        struct_lds_sano_norm(index).struct_VSCi_noises(j).psif_pam_noise = psif_pam_noise; % PAM lado derecho
        struct_lds_sano_norm(index).struct_VSCd_noises(j).psif_vscd_noise = psif_vscd_noise; % VSCd
        struct_lds_sano_norm(index).struct_VSCi_noises(j).psif_vsci_noise = psif_vsci_noise; % VSCi

        % Almacenando frecuencias (para mostrar escalograma)
        struct_lds_sano_norm(index).struct_VSCd_noises(j).freqs_pam_noise = freqs_pam_noise; % PAM lado derecho
        struct_lds_sano_norm(index).struct_VSCi_noises(j).freqs_pam_noise = freqs_pam_noise; % PAM lado derecho
        struct_lds_sano_norm(index).struct_VSCd_noises(j).freqs_vscd_noise = freqs_vscd_noise; % VSCd
        struct_lds_sano_norm(index).struct_VSCi_noises(j).freqs_vsci_noise = freqs_vsci_noise; % VSCi 
        %==========================================================================================================================================

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%%%% PACIENTE TEC %%%%%%%%
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%
        name_csv_pam_tec = pam_noises_csv_tec(j).name; % Nombre del archivo.csv PAMnoises
        name_csv_vscd_tec = vscd_noises_csvd_tec(j).name; % Nombre del archivo.csv VSCdnoises
        name_csv_vsci_tec = vsci_noises_csvi_tec(j).name; % Nombre del archivo.csv VSCinoises
        % Verificar tripleta de datos vinculados (ej: 1_DENI1005_ruidoPAM1.csv | 1_DENI1005_ruidoVSCd1.csv | 1_DENI1005_ruidoVSCi1.csv)
        %fprintf("%s | %s | %s", name_csv_pam_tec, name_csv_vscd_tec, name_csv_vsci_tec); 
    
        path_pam_noises_tecs = fullfile(path_pam_noises_tec, name_csv_pam_tec); % Ruta completa de la carpeta PAMnoises
        path_vscd_noises_tecs = fullfile(path_vscd_noises_tec, name_csv_vscd_tec); % Ruta completa de la carpeta VSCdnoises
        path_vsci_noises_tecs = fullfile(path_vsci_noises_tec, name_csv_vsci_tec); % Ruta completa de la carpeta VSCinoises


        % Leer el contenido del archivo CSV en carpeta PAMnoises
        data_pam_noises_tec = readmatrix(path_pam_noises_tecs);
        % Leer el contenido del archivo CSV en la carpeta VSCdnoises
        data_vscd_noises_tec = readmatrix(path_vscd_noises_tecs);
        % Leer el contenido del archivo CSV en la carpeta VSCinoises
        data_vsci_noises_tec = readmatrix(path_vsci_noises_tecs); 

        % Asignar a la estructura
        struct_lds_tec_norm(index).struct_VSCd_noises(j).name_file_noise = ['Ruido', num2str(j)]; % Guardar el nombre del archivo
        % Lado derecho cerebro
        struct_lds_tec_norm(index).struct_VSCd_noises(j).pam_noise = data_pam_noises_tec; % Guardar la senal PAM con ruido
        struct_lds_tec_norm(index).struct_VSCd_noises(j).vscd_noise = data_vscd_noises_tec; % Guardar la senal VSCd con ruido
        % Lado izquierdo cerebro
        struct_lds_tec_norm(index).struct_VSCi_noises(j).pam_noise = data_pam_noises_tec; % Guardar la senal PAM con ruido
        struct_lds_tec_norm(index).struct_VSCi_noises(j).vsci_noise = data_vsci_noises_tec; % Guardar la senal VSCi con ruido


        %##############################################################################################
        %######## APLICACION DE CWT Y GUARDADO DE PARAMETROS EN ESTRUCTURA DE SANOS Y TEC #############
        %##############################################################################################
    
        % WAVELET MADRE CONTINUA A UTILIZAR: Analytic Morlet (Gabor)
        % Wavelet:amor
        
        % [PAM NOISE - CWT]
        [coefs_pam_noise, freqs_pam_noise, scalcfs_pam_noise, psif_pam_noise] = cwt(struct_lds_tec_norm(index).struct_VSCd_noises(j).pam_noise);
        % [VSC NOISE - CWT]
        [coefs_vscd_noise, freqs_vscd_noise, scalcfs_vscd_noise, psif_vscd_noise] = cwt(struct_lds_tec_norm(index).struct_VSCd_noises(j).vscd_noise);
        % [VSC NOISE - CWT]
        [coefs_vsci_noise, freqs_vsci_noise, scalcfs_vsci_noise, psif_vsci_noise] = cwt(struct_lds_tec_norm(index).struct_VSCi_noises(j).vsci_noise);

        
        % Almacenando nueva informacion en la respectiva estructura de senales
        % con ruido:
        
        % Almacenando coeficientes (matriz compleja)
        struct_lds_tec_norm(index).struct_VSCd_noises(j).matrix_complex_pam = coefs_pam_noise; % PAM lado derecho
        struct_lds_tec_norm(index).struct_VSCi_noises(j).matrix_complex_pam = coefs_pam_noise; % PAM lado izquierdo
        struct_lds_tec_norm(index).struct_VSCd_noises(j).matrix_complex_vscd = coefs_vscd_noise; % VSCd
        struct_lds_tec_norm(index).struct_VSCi_noises(j).matrix_complex_vsci = coefs_vsci_noise; % VSCi
    
        % Almacenando escalas de coeficientes (vector fila 1D real , largo 1024)
        struct_lds_tec_norm(index).struct_VSCd_noises(j).scalscfs_pam_noise = scalcfs_pam_noise; % PAM lado derecho
        struct_lds_tec_norm(index).struct_VSCi_noises(j).scalscfs_pam_noise = scalcfs_pam_noise; % PAM lado derecho
        struct_lds_tec_norm(index).struct_VSCd_noises(j).scalscfs_vscd_noise = scalcfs_vscd_noise; % VSCd
        struct_lds_tec_norm(index).struct_VSCi_noises(j).scalscfs_vsci_noise = scalcfs_vsci_noise; % VSCd
    
        % Almacenando respuestas de filtros (matriz real 30x1024)
        struct_lds_tec_norm(index).struct_VSCd_noises(j).psif_pam_noise = psif_pam_noise; % PAM lado derecho
        struct_lds_tec_norm(index).struct_VSCi_noises(j).psif_pam_noise = psif_pam_noise; % PAM lado derecho
        struct_lds_tec_norm(index).struct_VSCd_noises(j).psif_vscd_noise = psif_vscd_noise; % VSCd
        struct_lds_tec_norm(index).struct_VSCi_noises(j).psif_vsci_noise = psif_vsci_noise; % VSCi

        % Almacenando frecuencias (para mostrar escalograma)
        struct_lds_tec_norm(index).struct_VSCd_noises(j).freqs_pam_noise = freqs_pam_noise; % PAM lado derecho
        struct_lds_tec_norm(index).struct_VSCi_noises(j).freqs_pam_noise = freqs_pam_noise; % PAM lado derecho
        struct_lds_tec_norm(index).struct_VSCd_noises(j).freqs_vscd_noise = freqs_vscd_noise; % VSCd
        struct_lds_tec_norm(index).struct_VSCi_noises(j).freqs_vsci_noise = freqs_vsci_noise; % VSCi 
        %==========================================================================================================================================
    end
    
    % Aqui ya se han calculados todas las cwt de cada senal normalizada con ruido de
    % PAM, VSCd y VSCd. Ahora se procede a calcular los coeficientes(matrices complejas)
    % de las senales originales sin ruido.

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % PARA SENALES ORIGINALES NORMALIZADAS DE PAM, VSCd Y VSCi del sujeto index:
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%
    % SUJETO SANO %
    %%%%%%%%%%%%%%%
    % [ORIGINAL PAM - CWT] - NORMALIZADA
    [coefs_original_pam, freqs_original_pam, scalcfs_original_pam, psif_original_pam] = cwt(struct_lds_sano_norm(index).signal_pam_norm);
    % [ORIGINAL VSCd - CWT] - NORMALIZADA
    [coefs_original_vscd, freqs_original_vscd, scalcfs_original_vscd, psif_original_vscd] = cwt(struct_lds_sano_norm(index).signal_vscd_norm);
    % [ORIGINAL VSCi- CWT] - NORMALIZADA
    [coefs_original_vsci, freqs_original_vsci, scalcfs_original_vsci, psif_original_vsci] = cwt(struct_lds_sano_norm(index).signal_vsci_norm);
    
    % SUJETO SANO
    % Almacenando datos del sujeto index en la respectiva estructura
    % SUJETO SANO - ORIGINAL PAM - NORMALIZADA
    struct_lds_sano_norm(index).struct_original_PAM(1).matrix_complex_original_pam = coefs_original_pam;
    struct_lds_sano_norm(index).struct_original_PAM(1).scalscfs_original_pam = scalcfs_original_pam;
    struct_lds_sano_norm(index).struct_original_PAM(1).psif_original_pam = psif_original_pam;
    struct_lds_sano_norm(index).struct_original_PAM(1).freqs_original_pam = freqs_original_pam;
    % SUJETO SANO - ORIGINAL VSCd - NORMALIZADA
    struct_lds_sano_norm(index).struct_original_VSCd(1).matrix_complex_original_vscd = coefs_original_vscd;
    struct_lds_sano_norm(index).struct_original_VSCd(1).scalscfs_original_vscd = scalcfs_original_vscd;
    struct_lds_sano_norm(index).struct_original_VSCd(1).psif_original_vscd = psif_original_vscd;
    struct_lds_sano_norm(index).struct_original_VSCd(1).freqs_original_vscd = freqs_original_vscd;
    % SUJETO SANO - ORIGINAL VSCi - NORMALIZADA
    struct_lds_sano_norm(index).struct_original_VSCi(1).matrix_complex_original_vsci = coefs_original_vsci;
    struct_lds_sano_norm(index).struct_original_VSCi(1).scalscfs_original_vsci = scalcfs_original_vsci;
    struct_lds_sano_norm(index).struct_original_VSCi(1).psif_original_vsci = psif_original_vsci;
    struct_lds_sano_norm(index).struct_original_VSCi(1).freqs_original_vsci = freqs_original_vsci;
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%
    % PACIENTE TEC %
    %%%%%%%%%%%%%%%%
    % [ORIGINAL PAM - CWT] - NORMALIZADA
    [coefs_original_pam, freqs_original_pam, scalcfs_original_pam, psif_original_pam] = cwt(struct_lds_tec_norm(index).signal_pam_norm);
    % [ORIGINAL VSCd - CWT] - NORMALIZADA
    [coefs_original_vscd, freqs_original_vscd, scalcfs_original_vscd, psif_original_vscd] = cwt(struct_lds_tec_norm(index).signal_vscd_norm);
    % [ORIGINAL VSCi- CWT] - NORMALIZADA
    [coefs_original_vsci, freqs_original_vsci, scalcfs_original_vsci, psif_original_vsci] = cwt(struct_lds_tec_norm(index).signal_vsci_norm);
    
    % PACIENTE TEC
    % Almacenando datos del sujeto index en la respectiva estructura
    % PACIENTE TEC - ORIGINAL PAM
    struct_lds_tec_norm(index).struct_original_PAM(1).matrix_complex_original_pam = coefs_original_pam;
    struct_lds_tec_norm(index).struct_original_PAM(1).scalscfs_original_pam = scalcfs_original_pam;
    struct_lds_tec_norm(index).struct_original_PAM(1).psif_original_pam = psif_original_pam;
    struct_lds_tec_norm(index).struct_original_PAM(1).freqs_original_pam = freqs_original_pam;
    % PACIENTE TEC - ORIGINAL VSCd
    struct_lds_tec_norm(index).struct_original_VSCd(1).matrix_complex_original_vscd = coefs_original_vscd;
    struct_lds_tec_norm(index).struct_original_VSCd(1).scalscfs_original_vscd = scalcfs_original_vscd;
    struct_lds_tec_norm(index).struct_original_VSCd(1).psif_original_vscd = psif_original_vscd;
    struct_lds_tec_norm(index).struct_original_VSCd(1).freqs_original_vscd = freqs_original_vscd;
    % PACIENTE TEC - ORIGINAL VSCi
    struct_lds_tec_norm(index).struct_original_VSCi(1).matrix_complex_original_vsci = coefs_original_vsci;
    struct_lds_tec_norm(index).struct_original_VSCi(1).scalscfs_original_vsci = scalcfs_original_vsci;
    struct_lds_tec_norm(index).struct_original_VSCi(1).psif_original_vsci = psif_original_vsci;
    struct_lds_tec_norm(index).struct_original_VSCi(1).freqs_original_vsci = freqs_original_vsci;
end


% Especifica el directorio donde deseas guardar la estructura
directory_structs = 'D:\TT\Memoria\CodigoFuenteNormalized\codigo_matlab\codigo_fuente\Estructuras_SANOS_TEC';

%============== Sanos ==================================================
% Especifica el nombre del archivo
filename_struct_sano = 'struct_lds_sano_norm.mat';
% Crea la ruta completa del archivo
filepath_struct_sano = fullfile(directory_structs, filename_struct_sano);
% Guarda la estructura en el archivo .mat
save(filepath_struct_sano, 'struct_lds_sano_norm', '-v7.3');
% Mensaje de confirmación
fprintf("(*) La estructura para sujetos sanos normalizados se ha guardado correctamente\n");

%============== TEC ==================================================
% Especifica el nombre del archivo
filename_struct_tec = 'struct_lds_tec_norm.mat';
% Crea la ruta completa del archivo
filepath_struct_tec = fullfile(directory_structs, filename_struct_tec);
% Guarda la estructura en el archivo .mat
save(filepath_struct_tec, 'struct_lds_tec_norm', '-v7.3');
% Mensaje de confirmación
fprintf("(*) La estructura para pacientes TEC normalizados se ha guardado correctamente\n");


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% GUARDAR MATRICES COMPLEJAS (COEFICIENTES) EN FORMATO ".mat" -> ENTRENAR RED U-NET %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% Almacenar matrices complejas pam y vsc en carpetas especificas para 
% luego trabajar con la red profunda en python. Para ello se importan 
% las matrices en formato.mat y luego en python se utiliza un script
% para transformar dicho formato a npy.
direct_sanos = 'D:/TT/Memoria/CodigoFuenteNormalized/codigo_matlab/codigo_fuente/Signals_LDS_Norm/SANOS';
direct_tecs = 'D:/TT/Memoria/CodigoFuenteNormalized/codigo_matlab/codigo_fuente/Signals_LDS_Norm/TEC';

% Obtener los nombres de las carpetas dentro del directorio de SANOS
folders_sanos = dir(direct_sanos);
foldernames_sanos = {folders_sanos([folders_sanos.isdir]).name}; % se obtiene los nombres de las carpetas
% Eliminar los nombres '.' y '..' que representan el directorio actual y el directorio padre
foldernames_sanos = setdiff(foldernames_sanos, {'.', '..'}); % vector fila que almcena los nombres de todas las carpetas de sujetos sanos


% Obtener los nombres de las carpetas dentro del directorio de TEC
folders_tecs = dir(direct_tecs);
foldernames_tecs = {folders_tecs([folders_tecs.isdir]).name}; % se obtiene los nombres de las carpetas
% Eliminar los nombres '.' y '..' que representan el directorio actual y el directorio padre
foldernames_tecs = setdiff(foldernames_tecs, {'.', '..'}); % vector fila que almcena los nombres de todas las carpetas de pacientes tec


%################################################
% Guardar las matrices complejas en archivos .mat
%################################################
num_matrix_complexs = num_of_noises_signals;
for i = 1:num_people
    % Se deben crear 3 carpetas para cada sujeto sano y paciente TEC. una
    % carpeta de matriz_compleja_pam, matriz_compleja_vscd y
    % matriz_compleja_vsci
    direct_folder_sano_i = fullfile(direct_sanos, foldernames_sanos{i}); % carpeta del sujeto sano posicion i
    direct_folder_tec_i = fullfile(direct_tecs, foldernames_tecs{i}); % carpeta del paciente tec posicion i

    % Creando las respectivas 3 carpetas, sino existen se crean.
    % Directorios para guardar los archivos.mat asociados a los inputs de coeficientes

    % Nombres d que tendran las respectivas carpetas:
    name_folder_pam = '/PAMnoises_matrixcomplex_mat';
    name_folder_vscd = '/VSCdnoises_matrixcomplex_mat';
    name_folder_vsci = '/VSCinoises_matrixcomplex_mat';
    % Para las matrices complejas de senales originales:
    name_folder_original_pam = '/PAMoriginal_matrixcomplex';
    name_folder_original_vscd = '/VSCdoriginal_matrixcomplex';
    name_folder_original_vsci = '/VSCioriginal_matrixcomplex';
    
    % Directorio donde se crearan dichas carpetas (3 total:
    % name_folder_pam, name_folder_vscd y name_folder_vsci) - SANO ***
    direct_final_cfs_pam_sano = fullfile(direct_folder_sano_i, name_folder_pam);
    direct_final_cfs_vscd_sano = fullfile(direct_folder_sano_i, name_folder_vscd);
    direct_final_cfs_vsci_sano = fullfile(direct_folder_sano_i, name_folder_vsci);
    % Directorios para senales originales
    direct_final_cfs_original_pam_sano = fullfile(direct_folder_sano_i, name_folder_original_pam);
    direct_final_cfs_original_vscd_sano = fullfile(direct_folder_sano_i, name_folder_original_vscd);
    direct_final_cfs_original_vsci_sano = fullfile(direct_folder_sano_i, name_folder_original_vsci);
    
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Directorio donde se crearan dichas carpetas (3 total:
    % name_folder_pam, name_folder_vscd y name_folder_vsci) - TEC ***
    direct_final_cfs_pam_tec = fullfile(direct_folder_tec_i, name_folder_pam);
    direct_final_cfs_vscd_tec = fullfile(direct_folder_tec_i, name_folder_vscd);
    direct_final_cfs_vsci_tec = fullfile(direct_folder_tec_i, name_folder_vsci);
    % Directorios para senales originales
    direct_final_cfs_original_pam_tec = fullfile(direct_folder_tec_i, name_folder_original_pam);
    direct_final_cfs_original_vscd_tec = fullfile(direct_folder_tec_i, name_folder_original_vscd);
    direct_final_cfs_original_vsci_tec = fullfile(direct_folder_tec_i, name_folder_original_vsci);

    % Creando carpetas si no existen...
    %%%% SANO %%%%
    if ~exist(direct_final_cfs_pam_sano, 'dir')
        mkdir(direct_final_cfs_pam_sano);
    end
    if ~exist(direct_final_cfs_vscd_sano, 'dir')
        mkdir(direct_final_cfs_vscd_sano);
    end
    if ~exist(direct_final_cfs_vsci_sano, 'dir')
        mkdir(direct_final_cfs_vsci_sano);
    end
    % senales originales
    if ~exist(direct_final_cfs_original_pam_sano, 'dir')
        mkdir(direct_final_cfs_original_pam_sano);
    end
    if ~exist(direct_final_cfs_original_vscd_sano, 'dir')
        mkdir(direct_final_cfs_original_vscd_sano);
    end
    if ~exist(direct_final_cfs_original_vsci_sano, 'dir')
        mkdir(direct_final_cfs_original_vsci_sano);
    end


    %%%% TEC %%%%
    if ~exist(direct_final_cfs_pam_tec, 'dir')
        mkdir(direct_final_cfs_pam_tec);
    end
    if ~exist(direct_final_cfs_vscd_tec, 'dir')
        mkdir(direct_final_cfs_vscd_tec);
    end
    if ~exist(direct_final_cfs_vsci_tec, 'dir')
        mkdir(direct_final_cfs_vsci_tec);
    end
    % senales originales
    if ~exist(direct_final_cfs_original_pam_tec, 'dir')
        mkdir(direct_final_cfs_original_pam_tec);
    end
    if ~exist(direct_final_cfs_original_vscd_tec, 'dir')
        mkdir(direct_final_cfs_original_vscd_tec);
    end
    if ~exist(direct_final_cfs_original_vsci_tec, 'dir')
        mkdir(direct_final_cfs_original_vsci_tec);
    end

    % Se obtiene el sujeto sano i y el paciente tec i de sus respectivas
    % estructuras.
    person_sano = struct_lds_sano_norm(i);
    person_tec = struct_lds_tec_norm(i);
    fprintf("[%i] Rellenando carpetas: SANO: %s || TEC: %s ...\n", i, foldernames_sanos{i}, foldernames_tecs{i});
    fprintf("[%i] Guardando matrices complejas (PAM, VSCd y VSCi) de: SANO %s || TEC: %s\n",i, person_sano.name_file, person_tec.name_file);
    for j = 1:num_matrix_complexs
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% SANO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        % Guardar matriz_complex_pam
        matrix_complex_pam_sano = person_sano.struct_VSCd_noises(j).matrix_complex_pam; % la PAM es la misma ya sea en VSCd o VSCi
        save(fullfile(direct_final_cfs_pam_sano, sprintf('matrix_complex_pam_noise_%d.mat', j)), 'matrix_complex_pam_sano') 
        % Guardar matriz_complex_vscd
        matrix_complex_vscd_sano = person_sano.struct_VSCd_noises(j).matrix_complex_vscd;
        save(fullfile(direct_final_cfs_vscd_sano, sprintf('matrix_complex_vscd_noise_%d.mat', j)), 'matrix_complex_vscd_sano');
        % Guardar matriz_complex_vsci
        matrix_complex_vsci_sano = person_sano.struct_VSCi_noises(j).matrix_complex_vsci;
        save(fullfile(direct_final_cfs_vsci_sano, sprintf('matrix_complex_vsci_noise_%d.mat', j)), 'matrix_complex_vsci_sano');
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% TEC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% 
        % Guardar matriz_complex_pam
        matrix_complex_pam_tec = person_tec.struct_VSCd_noises(j).matrix_complex_pam;
        save(fullfile(direct_final_cfs_pam_tec, sprintf('matrix_complex_pam_noise_%d.mat', j)), 'matrix_complex_pam_tec');
        % Guardar matriz_complex_vscd
        matrix_complex_vscd_tec = person_tec.struct_VSCd_noises(j).matrix_complex_vscd;
        save(fullfile(direct_final_cfs_vscd_tec, sprintf('matrix_complex_vscd_noise_%d.mat', j)), 'matrix_complex_vscd_tec');
        % Guardar matriz_complex_vsci
        matrix_complex_vsci_tec = person_tec.struct_VSCi_noises(j).matrix_complex_vsci;
        save(fullfile(direct_final_cfs_vsci_tec, sprintf('matrix_complex_vsci_noise_%d.mat', j)), 'matrix_complex_vsci_tec');
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    end
    % PARA SUJETO SANO
    % Guardar matriz_complex_original_pam
    matrix_complex_original_pam_sano = person_sano.struct_original_PAM(1).matrix_complex_original_pam; % la PAM es la misma ya sea en VSCd o VSCi
    save(fullfile(direct_final_cfs_original_pam_sano, 'matrix_complex_original_pam.mat'), 'matrix_complex_original_pam_sano');
    % Guardar matriz_complex_original_vscd
    matrix_complex_original_vscd_sano = person_sano.struct_original_VSCd(1).matrix_complex_original_vscd;
    save(fullfile(direct_final_cfs_original_vscd_sano, 'matrix_complex_original_vscd.mat'), 'matrix_complex_original_vscd_sano');
    % Guardar matriz_complex_original_vsci
    matrix_complex_original_vsci_sano = person_sano.struct_original_VSCi(1).matrix_complex_original_vsci;
    save(fullfile(direct_final_cfs_original_vsci_sano, 'matrix_complex_original_vsci.mat'), 'matrix_complex_original_vsci_sano');

    % PARA PACIENTE TEC
    % Guardar matriz_complex_original_pam
    matrix_complex_original_pam_tec = person_tec.struct_original_PAM(1).matrix_complex_original_pam; % la PAM es la misma ya sea en VSCd o VSCi
    save(fullfile(direct_final_cfs_original_pam_tec, 'matrix_complex_original_pam.mat'), 'matrix_complex_original_pam_tec');
     % Guardar matriz_complex_original_vscd
    matrix_complex_original_vscd_tec = person_tec.struct_original_VSCd(1).matrix_complex_original_vscd;
    save(fullfile(direct_final_cfs_original_vscd_tec, 'matrix_complex_original_vscd.mat'), 'matrix_complex_original_vscd_tec');
    % Guardar matriz_complex_original_vsci
    matrix_complex_original_vsci_tec = person_tec.struct_original_VSCi(1).matrix_complex_original_vsci;
    save(fullfile(direct_final_cfs_original_vsci_tec, 'matrix_complex_original_vsci.mat'), 'matrix_complex_original_vsci_tec');
end




%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% ANALISIS DE LA ESTIMACION DE LOS COEFICIENTES POR MEDIO DE UNA COMPARACION DE CURVAS DE LAS SENALES %%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%{
%###################################################################
%###################################################################
% Se calcula la ICWT de la senal VSCd o VSCi con la matriz compleja
% (coeficientes) ORIGINAL
%###################################################################
%###################################################################

% Se obtienes 2 de los 3 parametros para calcular ICWT de la senal VSC. El
% terer parametro (mas importante) corresponde a los coeficientes o
% matriz compleja que se obtiene de la prediccion de la red U-net

% Selecionar estado (SANO/TEC), lado (VSC derecho o izquierdo) e individuo a analizar -->
% Esto se realiza para comparar la curva de VSC de un individuo con la
% curva de VSC predicha (solo para ver calidad de la red)
estado = 'SANOS';
persona = '11_JULE';
lado = 'derecho';
lado_abrev = '';
num_people = 27;
%Variables (vectores) donde se almacenaran los parametros correspondientes
%al estado, persona y lado del individuo a analizar:
coefs_vsc_original_signal_to_predict = [];
freqs_vsc_original_signal_to_predict = [];
scalcfs_vsc_original_signal_to_predict = [];
psif_vsc_original_signal_to_predict = [];

pivote = 0; % indice de la estructura donde se alamcena el individuo que se desea analizar:
% Ciclo que hace get de los parametros necesarios para luego aplicar la
% ICWT.
for i = 1:num_people % ciclo que recorre cada instancia de las estructuras (27: cantidad de individuos)
    if strcmp(estado, 'SANOS')
        if strcmp(struct_lds_sano(i).name_file, persona) 
            pivote = i;
            if strcmp(lado, 'derecho')
                lado_abrev = 'VSCd';
                disp(persona);
                disp('GET sano-derecho');
                coefs_vsc_original_signal_to_predict = struct_lds_sano(pivote).struct_original_VSCd.matrix_complex_original_vscd;
                freqs_vsc_original_signal_to_predict = struct_lds_sano(pivote).struct_original_VSCd.freqs_original_vscd;
                scalcfs_vsc_original_signal_to_predict = struct_lds_sano(pivote).struct_original_VSCd.scalscfs_original_vscd;
                psif_vsc_original_signal_to_predict = struct_lds_sano(pivote).struct_original_VSCd.psif_original_vscd;
            else %lado=izquierdo
                lado_abrev = 'VSCi';
                disp(persona);
                disp('GET sano-izquierdo');
                coefs_vsc_original_signal_to_predict = struct_lds_sano(pivote).struct_original_VSCi.matrix_complex_original_vsci;
                freqs_vsc_original_signal_to_predict = struct_lds_sano(pivote).struct_original_VSCi.freqs_original_vsci;
                scalcfs_vsc_original_signal_to_predict = struct_lds_sano(pivote).struct_original_VSCi.scalscfs_original_vsci;
                psif_vsc_original_signal_to_predict = struct_lds_sano(pivote).struct_original_VSCi.psif_original_vsci;
            end
        end 
    else%estado=TEC
       if strcmp(struct_lds_tec(i).name_file, persona)
            pivote = i;
            if strcmp(lado, 'derecho')
                lado_abrev = 'VSCd';
                disp(persona);
                disp('GET tec-derecho');
                coefs_vsc_original_signal_to_predict = struct_lds_tec(pivote).struct_original_VSCd.matrix_complex_original_vscd;
                freqs_vsc_original_signal_to_predict = struct_lds_tec(pivote).struct_original_VSCd.freqs_original_vscd;
                scalcfs_vsc_original_signal_to_predict = struct_lds_tec(pivote).struct_original_VSCd.scalscfs_original_vscd;
                psif_vsc_original_signal_to_predict = struct_lds_tec(pivote).struct_original_VSCd.psif_original_vscd;
            else %lado=izquierdo
                lado_abrev = 'VSCi';
                disp(persona);
                disp('GET tec-izquierdo');
                coefs_vsc_original_signal_to_predict = struct_lds_tec(pivote).struct_original_VSCi.matrix_complex_original_vsci;
                freqs_vsc_original_signal_to_predict = struct_lds_tec(pivote).struct_original_VSCi.freqs_original_vsci;
                scalcfs_vsc_original_signal_to_predict = struct_lds_tec(pivote).struct_original_VSCi.scalscfs_original_vsci;
                psif_vsc_original_signal_to_predict = struct_lds_tec(pivote).struct_original_VSCi.psif_original_vsci;
            end
       end  
    end   
end    



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% CREACION DE CARPETA DONDE SE ALMACENARAN LOS COEFICIENTES PREDICHOS (SOLO PARA ANALIZAR CALIDAD DE LA RED) %%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

direct_sanos = 'D:/TT/Memoria/MemoriaCodigoFuentev3/codigo_matlab/codigo_fuente/signals_LDS_Inputs_Steps_and_PAMsignals/SANOS';
direct_tecs = 'D:/TT/Memoria/MemoriaCodigoFuentev3/codigo_matlab/codigo_fuente/signals_LDS_Inputs_Steps_and_PAMsignals/TEC';

% Obtener los nombres de las carpetas dentro del directorio de SANOS
folders_sanos = dir(direct_sanos);
foldernames_sanos = {folders_sanos([folders_sanos.isdir]).name}; % se obtiene los nombres de las carpetas
% Eliminar los nombres '.' y '..' que representan el directorio actual y el directorio padre
foldernames_sanos = setdiff(foldernames_sanos, {'.', '..'}); % vector fila que almcena los nombres de todas las carpetas de sujetos sanos


% Obtener los nombres de las carpetas dentro del directorio de TEC
folders_tecs = dir(direct_tecs);
foldernames_tecs = {folders_tecs([folders_tecs.isdir]).name}; % se obtiene los nombres de las carpetas
% Eliminar los nombres '.' y '..' que representan el directorio actual y el directorio padre
foldernames_tecs = setdiff(foldernames_tecs, {'.', '..'}); % vector fila que almcena los nombres de todas las carpetas de pacientes tec


%################################################
% Guardar las matrices complejas en archivos .mat
%################################################
for i = 1:num_people
    % Se deben crear 3 carpetas para cada sujeto sano y paciente TEC. una
    % carpeta de matriz_compleja_pam, matriz_compleja_vscd y
    % matriz_compleja_vsci
    direct_folder_sano_i = fullfile(direct_sanos, foldernames_sanos{i}); % carpeta del sujeto sano posicion i
    direct_folder_tec_i = fullfile(direct_tecs, foldernames_tecs{i}); % carpeta del paciente tec posicion i

    % Creando las respectivas 2 carpetas, sino existen se crean.
    % Directorios para guardar los coeficientes predichos de VSCd y VSCi

    % Nombre que tendran las respectivas carpetas:
    name_folder_CoefficientsPredicted_VSCd = '/CoefficientsPredicted_VSCd'; % para coeficientes predichos de VSC derecha
    name_folder_CoefficientsPredicted_VSCi = '/CoefficientsPredicted_VSCi'; % para coeficientes predichos de VSC izquierda

    % Directorio donde se crearan dichas carpetas (2 total:
    % name_folder_CoefficientsPredicted_VSCd y name_folderCoefficientsPredicted_VSCi)
    % *** SANO ***
    direct_final_CoefficientsPredicted_VSCd_sano = fullfile(direct_folder_sano_i, name_folder_CoefficientsPredicted_VSCd);
    direct_final_CoefficientsPredicted_VSCi_sano = fullfile(direct_folder_sano_i, name_folder_CoefficientsPredicted_VSCi);

    % Directorio donde se crearan dichas carpetas (2 total:
    % name_folder_CoefficientsPredicted_VSCd y name_folder_CoefficientsPredicted_VSCi)
    % *** TEC ***
    direct_final_CoefficientsPredicted_VSCd_tec = fullfile(direct_folder_tec_i, name_folder_CoefficientsPredicted_VSCd);
    direct_final_CoefficientsPredicted_VSCi_tec = fullfile(direct_folder_tec_i, name_folder_CoefficientsPredicted_VSCi);

    % Creando carpetas si no existen...
    %%%% SANO %%%%
    if ~exist(direct_final_CoefficientsPredicted_VSCd_sano, 'dir')
        mkdir(direct_final_CoefficientsPredicted_VSCd_sano);
    end
    if ~exist(direct_final_CoefficientsPredicted_VSCi_sano, 'dir')
        mkdir(direct_final_CoefficientsPredicted_VSCi_sano);
    end
    %%%%% TEC %%%%
    if ~exist(direct_final_CoefficientsPredicted_VSCd_tec, 'dir')
        mkdir(direct_final_CoefficientsPredicted_VSCd_tec);
    end
    if ~exist(direct_final_CoefficientsPredicted_VSCi_tec, 'dir')
        mkdir(direct_final_CoefficientsPredicted_VSCi_tec);
    end

end
%}



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% LECTURA DE COEFS PREDICHOS Y COMPARACION DE SENALES VSC ORIGINALES Y ESTIMADAS (CURVAS Y NMSE) %%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%{
% Especificar el directorio donde esta el archivo .mat
coefs_predicted_dir = strcat('D:/TT/Memoria/MemoriaCodigoFuentev3/codigo_matlab/codigo_fuente/signals_LDS/', estado, '/', persona, '/CoefficientsPredicted_', lado_abrev);
% Variables para almacenar el contenido leido por medio de load() (archivo.mat asociado a los coefs predichos)
coefs_predicted_path = '';
coefs_vsc_predicted_by_unet_struct = struct();
coefs_vsc_predicted_by_unet = [];
% Nombre del archivo .mat
coefs_predicted_filename  = '';
if strcmp(lado, 'derecho')
    coefs_predicted_filename = 'coefs_matrix_complex_vscd_predicted';
    % Ruta completa del archivo .mat
    coefs_predicted_path = fullfile(coefs_predicted_dir, coefs_predicted_filename);
    
    % Cargar el archivo .mat y guardar el contenido en una variable
    coefs_vsc_predicted_by_unet_struct = load(coefs_predicted_path);
    % see extrae la matriz compleja
    coefs_vsc_predicted_by_unet = cast(coefs_vsc_predicted_by_unet_struct(1).coefs_matrix_complex_vscd_predicted, 'double');

else%lado=izquierdo
    coefs_predicted_filename = 'coefs_matrix_complex_vsci_predicted';
    % Ruta completa del archivo .mat
    coefs_predicted_path = fullfile(coefs_predicted_dir, coefs_predicted_filename);
    
    % Cargar el archivo .mat y guardar el contenido en una variable
    coefs_vsc_predicted_by_unet_struct = load(coefs_predicted_path);
    % see extrae la matriz compleja
    coefs_vsc_predicted_by_unet = cast(coefs_vsc_predicted_by_unet_struct(1).coefs_matrix_complex_vsci_predicted, 'double');
end


% Se procede a aplicar la ICWT con el uso de los coeficientes predichos por
% la red U-net:
if strcmp(estado, "SANOS")
    if strcmp(lado, 'derecho')
        get_signal_vsc_estimated_with_coefs_unet = icwt(coefs_vsc_predicted_by_unet,[], ScalingCoefficients = scalcfs_vsc_original_signal_to_predict, AnalysisFilterBank = psif_vsc_original_signal_to_predict); % se realiza la transformada inversa continua de la senal
        get_signal_vsc_estimated_with_coefs_unet = get_signal_vsc_estimated_with_coefs_unet(:); % la reconstruccion de la senal estimada por los coeficientes predichos se pasa a formato vector columna
        error_signal_original_and_predicted = get_nmse(struct_lds_sano(pivote).signal_vscd, get_signal_vsc_estimated_with_coefs_unet); % se calcula el nmse
        persona_print = strrep(persona, '_', '\_'); % Reemplazar subrayado con subrayado escapado
        % comparar senales
        figure;
        hold on;
        plot(struct_lds_sano(pivote).signal_vscd, 'b'); % Senal original
        plot( get_signal_vsc_estimated_with_coefs_unet, 'r--'); % Senal reconstruida por amor
        title(sprintf('%s: Señal VSCd original vs estimada (NMSE: %.4e)', persona_print, error_signal_original_and_predicted));
        xlabel('Tiempo');
        ylabel('Amplitud');
        legend('Original', 'Reconstruida');
        hold off;
        
    else%lado=izquierdo
        get_signal_vsc_estimated_with_coefs_unet = icwt(coefs_vsc_predicted_by_unet,[], ScalingCoefficients = scalcfs_vsc_original_signal_to_predict, AnalysisFilterBank = psif_vsc_original_signal_to_predict); % se realiza la transformada inversa continua de la senal
        get_signal_vsc_estimated_with_coefs_unet = get_signal_vsc_estimated_with_coefs_unet(:); % la reconstruccion de la senal estimada por los coeficientes predichos se pasa a formato vector columna
        error_signal_original_and_predicted = get_nmse(struct_lds_sano(pivote).signal_vsci, get_signal_vsc_estimated_with_coefs_unet); % se calcula el nmse
        persona_print = strrep(persona, '_', '\_'); % Reemplazar subrayado con subrayado escapado
        % comparar senales
        figure;
        hold on;
        plot(struct_lds_sano(pivote).signal_vsci, 'b'); % Senal original
        plot( get_signal_vsc_estimated_with_coefs_unet, 'r--'); % Senal reconstruida por amor
        title(sprintf('%s: Señal VSCi original vs estimada (NMSE: %.4e)', persona_print, error_signal_original_and_predicted));
        xlabel('Tiempo');
        ylabel('Amplitud');
        legend('Original', 'Reconstruida');
        hold off;
    
    end

else%estado=TEC
    if strcmp(lado, 'derecho')
        get_signal_vsc_estimated_with_coefs_unet = icwt(coefs_vsc_predicted_by_unet,[], ScalingCoefficients = scalcfs_vsc_original_signal_to_predict, AnalysisFilterBank = psif_vsc_original_signal_to_predict); % se realiza la transformada inversa continua de la senal
        get_signal_vsc_estimated_with_coefs_unet = get_signal_vsc_estimated_with_coefs_unet(:); % la reconstruccion de la senal estimada por los coeficientes predichos se pasa a formato vector columna
        error_signal_original_and_predicted = get_nmse(struct_lds_tec(pivote).signal_vscd, get_signal_vsc_estimated_with_coefs_unet); % se calcula el nmse
        persona_print = strrep(persona, '_', '\_'); % Reemplazar subrayado con subrayado escapado
        % comparar senales
        figure;
        hold on;
        plot(struct_lds_tec(pivote).signal_vscd, 'b'); % Senal original
        plot( get_signal_vsc_estimated_with_coefs_unet, 'r--'); % Senal reconstruida por amor
        title(sprintf('%s: Señal VSCd original vs estimada (NMSE: %.4e)', persona_print, error_signal_original_and_predicted));
        xlabel('Tiempo');
        ylabel('Amplitud');
        legend('Original', 'Reconstruida');
        hold off;
    else
        get_signal_vsc_estimated_with_coefs_unet = icwt(coefs_vsc_predicted_by_unet,[], ScalingCoefficients = scalcfs_vsc_original_signal_to_predict, AnalysisFilterBank = psif_vsc_original_signal_to_predict); % se realiza la transformada inversa continua de la senal
        get_signal_vsc_estimated_with_coefs_unet = get_signal_vsc_estimated_with_coefs_unet(:); % la reconstruccion de la senal estimada por los coeficientes predichos se pasa a formato vector columna
        error_signal_original_and_predicted = get_nmse(struct_lds_tec(pivote).signal_vsci, get_signal_vsc_estimated_with_coefs_unet); % se calcula el nmse
        persona_print = strrep(persona, '_', '\_'); % Reemplazar subrayado con subrayado escapado
        % comparar senales
        figure;
        hold on;
        plot(struct_lds_tec(pivote).signal_vsci, 'b'); % Senal original
        plot( get_signal_vsc_estimated_with_coefs_unet, 'r--'); % Senal reconstruida por amor
        title(sprintf('%s: Señal VSCd original vs estimada (NMSE: %.4e)', persona_print, error_signal_original_and_predicted));
        xlabel('Tiempo');
        ylabel('Amplitud');
        legend('Original', 'Reconstruida');
        hold off;
    end
end
%}






%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%% GENERACION DE COEFICIENTES DE ESCALON UNITARIO INVERSO PARA PREDECIR RESPUESTA DE VSC %%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%{
%%%______ evaluando solo al sujeto 11_JULE (grafica de respuesta de VSCd)
persona = struct_lds_sano(2); %Se elige 11_JULE ya que su respuesta de vSC derecha no es buena
pam_persona = persona.signal_pam; %se selecciona la senal PAM de la persona
disp(persona);
[escalon_inverso_unitario, largo_escalon_ini] = get_step_no_normalized_testing(Ts, butterworth_order, cut_freq, pam_persona);
disp(length(largo_escalon_ini));
disp(length(escalon_inverso_unitario));


struct_minmaxpam(1) = struct('coefs_step', [], 'freqs_step', [], 'scalscfs_step', [], 'psif_step', []);
% Aplicacion de CWT para obtener coeficientes
[coefs_step, freqs_step, scalscfs_step, psif_step] = cwt(escalon_inverso_unitario);
struct_minmaxpam(1).coefs_step = coefs_step;
struct_minmaxpam(1).freqs_step = freqs_step;
struct_minmaxpam(1).scalscfs_step = scalscfs_step;
struct_minmaxpam(1).psif_step = psif_step;

% Directorio donde se guardara el archivo.mat de los coefs del escalon inverso unitario
dir_eiu = 'D:/TT/Memoria/MemoriaCodigoFuentev3/codigo_matlab/codigo_fuente/Estructuras_SANOS_TEC/';
% Guardar la matriz coefs_eui en un archivo .mat
save(fullfile(dir_eiu, 'coefs_step.mat'), 'coefs_step');
save(fullfile(dir_eiu, 'struct_minmaxpam.mat'), 'struct_minmaxpam');
%%%______
%}




% Se procede a guardar los coefs en formato.mat para probarlo en la red
% Este input de coefs de escalon unitario inverso es de uso particular, es
% decir, cada sujeto SANO y paciente TEC tiene un escalón inverso que esta
% escalado de acuerdo al max(PAM) y min(PAM). Esto sucede ya que la red
% no fue entrenada con datos normalizados, ya que el error NMSE aumentaba 
% con respecto a la salida de la red (coeficientes//respuesta VSC)

% CODIGO RAIZ - creacion de escalon inverso unitario:
% periodo de muestreo=0.2 [seg]
% filtro butterworth de 2do orden
% frecuencia de corte = 0.3 [Hz]
Ts=0.2;
butterworth_order = 2;
cut_freq = 0.3;
% Obtener escalon inverso unitario (1024 instacias) ~3.4min
% CREACION DE ESTRUCTURA QUE GUARDARA INFORMACION DE LOS ESCALONES DE CADA
% INDIVIDUO. struct_steps_sanos{struct_step, struct_step, ...} y
% struct_steps_tecs{struct_step, struct_step, ...}
struct_step_sanos_norm(num_people) = struct('nombre', '','coefs_step', [], 'scalscfs_step', [], 'psif_step', [], 'freqs_step', [], 'signal_step', []);%SANOS
struct_step_tecs_norm(num_people) = struct('nombre', '','coefs_step', [], 'scalscfs_step', [], 'psif_step', [], 'freqs_step', [], 'signal_step', []);%TECS


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%% LECTURA DE ARCHIVO - ESCALON INVERSO UNITARIO %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Llamada a funcion que crea el escalon y lo nomraliza con min-max:
step_norm = get_step_normalized(Ts, butterworth_order, cut_freq);





%bucle para recorrer todos los sujetos SANOS y luego pacientes TEC:
for i = 1:num_people    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%% SANO %%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    persona_sana = struct_lds_sano_norm(i); % se asigna un persona de acuerdo al indice en la estructura de sanos
    fprintf('(%i) Creando coeficientes de escalon inverso para sano: %s\n', i, persona_sana.name_file);
    pam_persona_sana = persona_sana.signal_pam_norm; %se selecciona la senal PAM de la persona i
    %CALCULO Y OBTENCION DE LA SENAL DEL ESCALON INVERSO
    escalon_inverso_unitario_persona_sana = get_step_normalized(Ts, butterworth_order, cut_freq);
    %CALCULO DE LA CWT() PARA OBTENER LOS COEFICIENTES (INPUT DE LA RED)
    [coefs_step, freqs_step, scalscfs_step, psif_step] = cwt(escalon_inverso_unitario_persona_sana);
    %ASIGNAR INFORMACION DE LA PERSONA SANA A SU RESPECTIVA ESTRUCTURA
    struct_step_sanos_norm(i).nombre = persona_sana.name_file;
    struct_step_sanos_norm(i).coefs_step = coefs_step;
    struct_step_sanos_norm(i).freqs_step = freqs_step;
    struct_step_sanos_norm(i).scalscfs_step = scalscfs_step;
    struct_step_sanos_norm(i).psif_step = psif_step;
    struct_step_sanos_norm(i).signal_step = escalon_inverso_unitario_persona_sana;
    
    %SE CREA CARPETA QUE GUARDARA EL ESCALON DE LA PERSONA SANA:
    dir_step_sano = strcat('D:/TT/Memoria/CodigoFuenteNormalized/codigo_matlab/codigo_fuente/signals_LDS_Norm/SANOS/', persona_sana.name_file, '/step');
    %%%% SANO %%%%
    if ~exist(dir_step_sano, 'dir')
        mkdir(dir_step_sano);
    end
    %SE GUARDAN LOS COEFICIENTES EN FORMATO .mat
    save(fullfile(dir_step_sano, 'coefs_step.mat'), 'coefs_step');
    
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%% TEC %%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    persona_tec = struct_lds_tec_norm(i); % se asigna un persona de acuerdo al indice en la estructura de tecs
    pam_persona_tec = persona_tec.signal_pam_norm; %se selecciona la senal PAM de la persona i
    fprintf('(%i) Creando coeficientes de escalon inverso para tec: %s\n', i, persona_tec.name_file);
    %CALCULO Y OBTENCION DE LA SENAL DEL ESCALON INVERSO
    escalon_inverso_unitario_persona_tec = get_step_normalized(Ts, butterworth_order, cut_freq);
    %CALCULO DE LA CWT() PARA OBTENER LOS COEFICIENTES (INPUT DE LA RED)
    [coefs_step, freqs_step, scalscfs_step, psif_step] = cwt(escalon_inverso_unitario_persona_tec);
    %ASIGNAR INFORMACION DE LA PERSONA TEC A SU RESPECTIVA ESTRUCTURA
    struct_step_tecs_norm(i).nombre = persona_tec.name_file;
    struct_step_tecs_norm(i).coefs_step = coefs_step;
    struct_step_tecs_norm(i).freqs_step = freqs_step;
    struct_step_tecs_norm(i).scalscfs_step = scalscfs_step;
    struct_step_tecs_norm(i).psif_step = psif_step;
    struct_step_tecs_norm(i).signal_step = escalon_inverso_unitario_persona_tec;
    
    %SE CREA CARPETA QUE GUARDARA EL ESCALON DE LA PERSONA TEC:
    dir_step_tec = strcat('D:/TT/Memoria/CodigoFuenteNormalized/codigo_matlab/codigo_fuente/signals_LDS_Norm/TEC/', persona_tec.name_file, '/step');
    %%%% TEC %%%%
    if ~exist(dir_step_tec, 'dir')
        mkdir(dir_step_tec);
    end
    %SE GUARDAN LOS COEFICIENTES EN FORMATO .mat
    save(fullfile(dir_step_tec, 'coefs_step.mat'), 'coefs_step');   
end
%{
Ts=0.2;
cut_freq=0.3;
order = 2;
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
[min, max, nn] = norm_min_max_original_signal(escalonInversoFinal);

 % Crear el vector de tiempo
t = (0:length(nn)-1) * Ts;
% Graficar el escalon unitario inverso para ver el comportamiento teorico
figure;
plot(t, nn, 'LineWidth', 2);
hold on;
xlabel('Tiempo (s)');
ylabel('cm/s');
title('Escalón Unitario Inverso (PRE): Suavizado con Filtro Butterworth 2do orden - Freq de corte de 0.3 [Hz] y periodo de muestreo de 0.2 [seg]');
legend('Suavizado');
xlim([0 45]);
grid on;
% Ajustar los marcadores del eje x para que vayan de 1 en 1 segundos
xticks(0:5:max(t));
%}


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%% GUARDADO DE ESTRUCTURAS DE STEP DE SANOS Y TECS %%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% SE GUARDA ESTRUCTURA ASOCIADA A LOS SANOS EN FORMATO .mat
dir_structs_sano = strcat('D:/TT/Memoria/CodigoFuenteNormalized/codigo_matlab/codigo_fuente/Estructuras_SANOS_TEC/');
% Guardar la una estructuras generales del escalon inverso unitario de cada sujeto SANO en un archivo .mat
save(fullfile(dir_structs_sano, 'struct_step_sanos_norm.mat'), 'struct_step_sanos_norm');

% SE GUARDA ESTRUCTURA ASOCIADA A LOS TECs EN FORMATO .mat
dir_structs_tec = strcat('D:/TT/Memoria/CodigoFuenteNormalized/codigo_matlab/codigo_fuente/Estructuras_SANOS_TEC/');
% Guardar la una estructuras generales del escalon inverso unitario de cada paciente TEC en un archivo .mat
save(fullfile(dir_structs_tec, 'struct_step_tecs_norm.mat'), 'struct_step_tecs_norm');



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%% COPIADO DE CARPETAS A NUEVOS DIRECTORIOS DESDE DIRECOTRIO BASE A DIRECTORIO CON LOS INPUTS PARA LA RED PARA %%%%% 
%%%%%%%%%%%%%% PREDECIR LA SEÑAL VSC                                                                                         %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Directorios para predecir el output por medio de la red unet
% Directorios origen
direct_sanos_to_copy = 'D:/TT/Memoria/CodigoFuenteNormalized/codigo_matlab/codigo_fuente/signals_LDS_Norm/SANOS';
direct_tecs_to_copy = 'D:/TT/Memoria/CodigoFuenteNormalized/codigo_matlab/codigo_fuente/signals_LDS_Norm/TEC';
% Directorios destino
direct_sanos = 'D:/TT/Memoria/CodigoFuenteNormalized/codigo_matlab/codigo_fuente/signals_LDS_NormPredictions/SANOS';
direct_tecs = 'D:/TT/Memoria/CodigoFuenteNormalized/codigo_matlab/codigo_fuente/signals_LDS_Normpredictions/TEC';
% Directorios para guardar los I/O para entrenar la red:
direct_sanos_train = 'D:/TT/Memoria/CodigoFuenteNormalized/codigo_matlab/codigo_fuente/signals_LDS_NormTraining/SANOS';
direct_tecs_train = 'D:/TT/Memoria/CodigoFuenteNormalized/codigo_matlab/codigo_fuente/signals_LDS_NormTraining/TEC';


% Obtener los nombres de las carpetas dentro del directorio de SANOS
folders_sanos = dir(direct_sanos_to_copy);
foldernames_sanos = {folders_sanos([folders_sanos.isdir]).name}; % se obtiene los nombres de las carpetas
% Eliminar los nombres '.' y '..' que representan el directorio actual y el directorio padre
foldernames_sanos = setdiff(foldernames_sanos, {'.', '..'}); % vector fila que almacena los nombres de todas las carpetas de sujetos sanos

% Obtener los nombres de las carpetas dentro del directorio de TEC
folders_tecs = dir(direct_tecs_to_copy);
foldernames_tecs = {folders_tecs([folders_tecs.isdir]).name}; % se obtiene los nombres de las carpetas
% Eliminar los nombres '.' y '..' que representan el directorio actual y el directorio padre
foldernames_tecs = setdiff(foldernames_tecs, {'.', '..'}); % vector fila que almacena los nombres de todas las carpetas de pacientes TEC


% Copiar las carpetas asociadas a los inputs y outputs para el
% el entrenamiento de la red (carpetas tensores 3d)
for i = 1:num_people
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %PAM
    % Directorios de origen
    source_folder_sano_pam_tensor3d = fullfile(direct_sanos_to_copy, foldernames_sanos{i}, 'PAMnoises_matrixcomplex_npy_tensor3d');
    source_folder_tec_pam_tensor3d = fullfile(direct_tecs_to_copy, foldernames_tecs{i}, 'PAMnoises_matrixcomplex_npy_tensor3d');
    % Directorios de destino
    dest_folder_sano_pam_tensor3d = fullfile(direct_sanos_train, foldernames_sanos{i}, 'PAMnoises_matrixcomplex_npy_tensor3d');
    dest_folder_tec_pam_tensor3d = fullfile(direct_tecs_train, foldernames_tecs{i}, 'PAMnoises_matrixcomplex_npy_tensor3d');


    %DIRECTORIOS ORIGEN
    % OBTENCION DE LAS CARPETAS SOLICITADAS DE LOS SUJETOS SANOS
    source_folder_sano_CoefsPredVSCd = fullfile(direct_sanos_to_copy, foldernames_sanos{i}, 'CoefficientsPredicted_VSCd');
    source_folder_sano_CoefsPredVSCi = fullfile(direct_sanos_to_copy, foldernames_sanos{i}, 'CoefficientsPredicted_VSCi');
    source_folder_sano_PAMoriginal = fullfile(direct_sanos_to_copy, foldernames_sanos{i}, 'PAMoriginal_matrixcomplex');
    source_folder_sano_Step = fullfile(direct_sanos_to_copy, foldernames_sanos{i}, 'step');
    % OBTENCION DE LAS CARPETAS SOLICITADAS DE LOS PACIENTES TEC
    source_folder_tec_CoefsPredVSCd = fullfile(direct_tecs_to_copy, foldernames_tecs{i}, 'CoefficientsPredicted_VSCd');
    source_folder_tec_CoefsPredVSCi = fullfile(direct_tecs_to_copy, foldernames_tecs{i}, 'CoefficientsPredicted_VSCi');
    source_folder_tec_PAMoriginal = fullfile(direct_tecs_to_copy, foldernames_tecs{i}, 'PAMoriginal_matrixcomplex');
    source_folder_tec_Step = fullfile(direct_tecs_to_copy, foldernames_tecs{i}, 'step');


    % DIRECTORIOS DESTINO
    % CREACION DE LAS CARPETAS NECESARIAS PARA SUJETOS SANOS
    dest_folder_sano_CoefsPredVSCd = fullfile(direct_sanos, foldernames_sanos{i}, 'CoefficientsPredicted_VSCd');
    dest_folder_sano_CoefsPredVSCi = fullfile(direct_sanos, foldernames_sanos{i}, 'CoefficientsPredicted_VSCi');
    dest_folder_sano_PAMoriginal = fullfile(direct_sanos, foldernames_sanos{i}, 'PAMoriginal_matrixcomplex');
    dest_folder_sano_Step = fullfile(direct_sanos, foldernames_sanos{i}, 'step');
    % CREACION DE LAS CARPETAS NECESARIAS PARA PACIENTES TEC
    dest_folder_tec_CoefsPredVSCd = fullfile(direct_tecs, foldernames_tecs{i}, 'CoefficientsPredicted_VSCd');
    dest_folder_tec_CoefsPredVSCi = fullfile(direct_tecs, foldernames_tecs{i}, 'CoefficientsPredicted_VSCi');
    dest_folder_tec_PAMoriginal = fullfile(direct_tecs, foldernames_tecs{i}, 'PAMoriginal_matrixcomplex');
    dest_folder_tec_Step = fullfile(direct_tecs, foldernames_tecs{i}, 'step');
    
   
    
    % CREACION DE CARPETAS DESTINO SI NO EXISTEN:
    % PARA SANOS:
    if ~exist(dest_folder_sano_CoefsPredVSCd, 'dir')
        mkdir(dest_folder_sano_CoefsPredVSCd);
    end
    if ~exist(dest_folder_sano_CoefsPredVSCi, 'dir')
        mkdir(dest_folder_sano_CoefsPredVSCi);
    end
    if ~exist(dest_folder_sano_PAMoriginal, 'dir')
        mkdir(dest_folder_sano_PAMoriginal);
    end
    if ~exist(dest_folder_sano_Step, 'dir')
        mkdir(dest_folder_sano_Step);
    end

    % PARA TECS:
    if ~exist(dest_folder_tec_CoefsPredVSCd, 'dir')
        mkdir(dest_folder_tec_CoefsPredVSCd);
    end
    if ~exist(dest_folder_tec_CoefsPredVSCi, 'dir')
        mkdir(dest_folder_tec_CoefsPredVSCi);
    end
    if ~exist(dest_folder_tec_PAMoriginal, 'dir')
        mkdir(dest_folder_tec_PAMoriginal);
    end
    if ~exist(dest_folder_tec_Step, 'dir')
        mkdir(dest_folder_tec_Step);
    end
   
    %SANO
    if ~exist(dest_folder_sano_pam_tensor3d, 'dir')
        mkdir(dest_folder_sano_pam_tensor3d);
    end
    %TEC
    if ~exist(dest_folder_tec_pam_tensor3d, 'dir')
        mkdir(dest_folder_tec_pam_tensor3d);
    end
   
    

    % COPIADO DE CARPETAS EN LOS DIRECTORIOS DESTINO:
    % PARA SANOS:
    if exist(source_folder_sano_CoefsPredVSCd, 'dir')
        copyfile(source_folder_sano_CoefsPredVSCd, dest_folder_sano_CoefsPredVSCd);
    else
        warning('La carpeta de origen %s no existe.', source_folder_sano_CoefsPredVSCd);
    end
    if exist(source_folder_sano_CoefsPredVSCi, 'dir')
        copyfile(source_folder_sano_CoefsPredVSCi, dest_folder_sano_CoefsPredVSCi);
    else
        warning('La carpeta de origen %s no existe.', source_folder_sano_CoefsPredVSCi);
    end
    if exist(source_folder_sano_PAMoriginal, 'dir')
        copyfile(source_folder_sano_PAMoriginal, dest_folder_sano_PAMoriginal);
    else
        warning('La carpeta de origen %s no existe.', source_folder_sano_PAMoriginal);
    end
    if exist(source_folder_sano_Step, 'dir')
        copyfile(source_folder_sano_Step, dest_folder_sano_Step);
    else
        warning('La carpeta de origen %s no existe.', source_folder_sano_Step);
    end

    % PARA TECS:
    if exist(source_folder_tec_CoefsPredVSCd, 'dir')
        copyfile(source_folder_tec_CoefsPredVSCd, dest_folder_tec_CoefsPredVSCd);
    else
        warning('La carpeta de origen %s no existe.', source_folder_tec_CoefsPredVSCd);
    end
    if exist(source_folder_tec_CoefsPredVSCi, 'dir')
        copyfile(source_folder_tec_CoefsPredVSCi, dest_folder_tec_CoefsPredVSCi);
    else
        warning('La carpeta de origen %s no existe.', source_folder_tec_CoefsPredVSCi);
    end
    if exist(source_folder_tec_PAMoriginal, 'dir')
        copyfile(source_folder_tec_PAMoriginal, dest_folder_tec_PAMoriginal);
    else
        warning('La carpeta de origen %s no existe.', source_folder_tec_PAMoriginal);
    end
    if exist(source_folder_tec_Step, 'dir')
        copyfile(source_folder_tec_Step, dest_folder_tec_Step);
    else
        warning('La carpeta de origen %s no existe.', source_folder_tec_Step);
    end

    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

    % Copiar la carpeta "PAMnoises_matrixcomplex_npy_tensor3d" para SANOS
    if exist(source_folder_sano_pam_tensor3d, 'dir')
        copyfile(source_folder_sano_pam_tensor3d, dest_folder_sano_pam_tensor3d);
    else
        warning('La carpeta de origen %s no existe.', source_folder_sano_pam_tensor3d);
    end
    % Copiar la carpeta "PAMnoises_matrixcomplex_npy_tensor3d" para TEC
    if exist(source_folder_tec_pam_tensor3d, 'dir')
        copyfile(source_folder_tec_pam_tensor3d, dest_folder_tec_pam_tensor3d);
    else
        warning('La carpeta de origen %s no existe.', source_folder_tec_pam_tensor3d);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %VSCd
    % Directorios de origen
    source_folder_sano_vscd_tensor3d = fullfile(direct_sanos_to_copy, foldernames_sanos{i}, 'VSCdnoises_matrixcomplex_npy_tensor3d');
    source_folder_tec_vscd_tensor3d = fullfile(direct_tecs_to_copy, foldernames_tecs{i}, 'VSCdnoises_matrixcomplex_npy_tensor3d');
    % Directorios de destino
    dest_folder_sano_vscd_tensor3d = fullfile(direct_sanos_train, foldernames_sanos{i}, 'VSCdnoises_matrixcomplex_npy_tensor3d');
    dest_folder_tec_vscd_tensor3d = fullfile(direct_tecs_train, foldernames_tecs{i}, 'VSCdnoises_matrixcomplex_npy_tensor3d');
    % Se crean directorios si no existen:
    %SANO
    if ~exist(dest_folder_sano_vscd_tensor3d, 'dir')
        mkdir(dest_folder_sano_vscd_tensor3d);
    end
    %TEC
    if ~exist(dest_folder_tec_vscd_tensor3d, 'dir')
        mkdir(dest_folder_tec_vscd_tensor3d);
    end
 
    % Copiar la carpeta "VSCdnoises_matrixcomplex_npy_tensor3d" para SANOS
    if exist(source_folder_sano_vscd_tensor3d, 'dir')
        copyfile(source_folder_sano_vscd_tensor3d, dest_folder_sano_vscd_tensor3d);
    else
        warning('La carpeta de origen %s no existe.', source_folder_sano_vscd_tensor3d);
    end
    % Copiar la carpeta "VSCdnoises_matrixcomplex_npy_tensor3d" para TEC
    if exist(source_folder_tec_vscd_tensor3d, 'dir')
        copyfile(source_folder_tec_vscd_tensor3d, dest_folder_tec_vscd_tensor3d);
    else
        warning('La carpeta de origen %s no existe.', source_folder_tec_vscd_tensor3d);
    end
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %VSCi
    % Directorios de origen
    source_folder_sano_vsci_tensor3d = fullfile(direct_sanos_to_copy, foldernames_sanos{i}, 'VSCinoises_matrixcomplex_npy_tensor3d');
    source_folder_tec_vsci_tensor3d = fullfile(direct_tecs_to_copy, foldernames_tecs{i}, 'VSCinoises_matrixcomplex_npy_tensor3d');
    % Directorios de destino
    dest_folder_sano_vsci_tensor3d = fullfile(direct_sanos_train, foldernames_sanos{i}, 'VSCinoises_matrixcomplex_npy_tensor3d');
    dest_folder_tec_vsci_tensor3d = fullfile(direct_tecs_train, foldernames_tecs{i}, 'VSCinoises_matrixcomplex_npy_tensor3d');
    % Se crean directorios si no existen:
    %SANO
    if ~exist(dest_folder_sano_vsci_tensor3d, 'dir')
        mkdir(dest_folder_sano_vsci_tensor3d);
    end
    %TEC
    if ~exist(dest_folder_tec_vsci_tensor3d, 'dir')
        mkdir(dest_folder_tec_vsci_tensor3d);
    end
 
    % Copiar la carpeta "VSCdnoises_matrixcomplex_npy_tensor3d" para SANOS
    if exist(source_folder_sano_vsci_tensor3d, 'dir')
        copyfile(source_folder_sano_vsci_tensor3d, dest_folder_sano_vsci_tensor3d);
    else
        warning('La carpeta de origen %s no existe.', source_folder_sano_vsci_tensor3d);
    end
    % Copiar la carpeta "VSCdnoises_matrixcomplex_npy_tensor3d" para TEC
    if exist(source_folder_tec_vsci_tensor3d, 'dir')
        copyfile(source_folder_tec_vsci_tensor3d, dest_folder_tec_vsci_tensor3d);
    else
        warning('La carpeta de origen %s no existe.', source_folder_tec_vsci_tensor3d);
    end
    
end


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%% PARA COPIAR LA CARPETA DE PAM-ORIGINAL-MATRIXCOMPLEX %%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copiar las carpetas asociadas a los inputs y outputs para el
% el entrenamiento de la red (carpetas tensores 3d)
for i = 1:num_people
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    %PAM
    % Directorios de destino
    dest_folder_sano_coefs_pred_vscd = fullfile(direct_sanos, foldernames_sanos{i}, 'CoefficientsPredicted_VSCd');
    dest_folder_sano_coefs_pred_vsci = fullfile(direct_sanos, foldernames_sanos{i}, 'CoefficientsPredicted_VSCi');

    dest_folder_tec_coefs_pred_vscd = fullfile(direct_tecs, foldernames_tecs{i}, 'CoefficientsPredicted_VSCd');
    dest_folder_tec_coefs_pred_vsci = fullfile(direct_tecs, foldernames_tecs{i}, 'CoefficientsPredicted_VSCi');
    % Se crean directorios si no existen:
    %SANO
    if ~exist(dest_folder_sano_coefs_pred_vscd, 'dir')
        mkdir(dest_folder_sano_coefs_pred_vscd);
    end
    if ~exist(dest_folder_sano_coefs_pred_vsci, 'dir')
        mkdir(dest_folder_sano_coefs_pred_vsci);
    end
    %TEC
    if ~exist(dest_folder_tec_coefs_pred_vscd, 'dir')
        mkdir(dest_folder_tec_coefs_pred_vscd);
    end
    if ~exist(dest_folder_tec_coefs_pred_vsci, 'dir')
        mkdir(dest_folder_tec_coefs_pred_vsci);
    end
end




