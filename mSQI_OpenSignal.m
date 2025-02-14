
% Nombres de los archivos de prueba: 
file1 = 'TopM_R1_2024-04-03.txt';
file2 = 'TopM_R2_2024-04-09.txt';
file3 = 'TopM_R3_2024-04-15.txt';
file4 = 'TopM_R4_2024-04-22.txt';

file5 = 'TopS_R1_2024-04-04.txt';
file6 = 'TopS_R2_2024-04-12.txt';
file7 = 'TopS_R3_2024-04-16.txt';
file8 = 'TopS_R4_2024-04-23.txt';

file9 = 'TopXS_R1_2024-04-05.txt';
file10 = 'TopXS_R2_2024-04-11.txt';
file11 = 'TopXS_R3__2024-04-18.txt';
file12 = 'TopXS_R4_2024-04-29.txt';

files_pruebaCortas_OpenSignal = {file1, file2, file3, file4, file5, file6, file7, file8, file9, file10, file11, file12};

% Loop sobre cada archivo
for file_index = 1:numel(files_pruebaCortas_OpenSignal)
    file_name = files_pruebaCortas_OpenSignal{file_index};
    
    % Leer los datos del archivo actual usando readmatrix
    %data = readmatrix(file_name); 


ecg_opensignal = ImportPluxData(file_name,3);%data(:, 3);% opensignal


n = length(ecg_opensignal);
indexes_escaleras = cell(1,n);

 [kSQI_01_vector,sSQI_01_vector, pSQI_01_vector,rel_powerLine01_vector, cSQI_01_vector, basSQI_01_vector,dSQI_01_vector,geometricMean_vector,averageGeometricMean] = mSQI(ecg_opensignal, 1000)


% Escribir el geometricMean_vector en un archivo de texto -> la usare luego para calcular la correlacion
% Convertir el vector en una tabla con el nombre de columna deseado
%aplico la traspuesta -> geometricMean_vector', para q el archivo tenga
%geometricMean_vector en formato columna
geometricMean_table = table(geometricMean_vector', 'VariableNames', {'geometricMean_vector'});

% Nombre del archivo CSV de salida
nombre_archivo = ['mSQI_OpenSignal_', file_name, '.csv'];

% Escribir la tabla en el archivo CSV
writetable(geometricMean_table, nombre_archivo);

 % Guardar el nombre del archivo en el array
    mSQI_archivos_generados{file_index} = nombre_archivo;
end

% Guardar el array de nombres de archivos generados
%save('mSQI_archivos.mat', 'mSQI_archivos_generados');

file_list = cell2table(mSQI_archivos_generados', 'VariableNames', {'NombreArchivo'});
csv_filename = 'mSQI_NombresArchivos_OpenSignal.csv';
writetable(file_list, csv_filename);
