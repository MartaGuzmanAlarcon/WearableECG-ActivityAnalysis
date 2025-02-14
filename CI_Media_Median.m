TEST = 0;

if (1)
    time_vector = 1:((7*60 + 59)*60); 
    
    files_TopM = {'opensignals_Escaleras_22-58-24.txt','opensignals_Sentada_22-53-55.txt', 'opensignals_tumbada_22-50-01.txt', 'opensignals_tumbada_22-50-01.txt'};

    files_TopS = {'opensignals_Escaleras_22-58-24.txt','opensignals_Sentada_22-53-55.txt', 'opensignals_tumbada_22-50-01.txt', 'opensignals_tumbada_22-50-01.txt'};

    files_TopXS = {'opensignals_Escaleras_22-58-24.txt','opensignals_Sentada_22-53-55.txt', 'opensignals_tumbada_22-50-01.txt', 'opensignals_tumbada_22-50-01.txt'};; 
    
else
     time_vector = 1:(((7*60 + 59)*60)*1000-360000); 
     
    files_TopM = {'TopM_R1_2024-04-03.txt', 
        'TopM_R2_2024-04-09.txt',
        'TopM_R3_2024-04-15.txt';
        'TopM_R4_2024-04-22.txt'};

    files_TopS = {'TopS_R1_2024-04-04.txt', 
        'TopS_R2_2024-04-12.txt',
        'TopS_R3_2024-04-16.txt',
        'TopS_R4_2024-04-23.txt';};

    files_TopXS = {'TopXS_R1_2024-04-05.txt', 
         'TopXS_R2_2024-04-11.txt',
         'TopXS_R3__2024-04-18.txt',
         'TopXS_R4_2024-04-29.txt'}; 

end 


fileSets = {files_TopM, files_TopS, files_TopXS};
indexes = cell(1, length(fileSets)); % indexes = cell(1, length(fileSets)); -> vector de 3 pos

for setIndex = 1: length(indexes)
    currentFiles = fileSets{setIndex};% ej: currentFiles= fileSets{1} -> files_TopM ->(...,...,....,....)
    indexes{setIndex} = cell(1, length(currentFiles)); % indexes{1}= a un vector con 4 pos 

    for fileIndex = 1:length(currentFiles) % fileIndex = 1:length(currentFiles)=4

        data = ImportPluxData(currentFiles{fileIndex}, 3);
        ecg = data(time_vector);
        [kSQI_01_vector, sSQI_01_vector, pSQI_01_vector, rel_powerLine01_vector, cSQI_01_vector, basSQI_01_vector, dSQI_01_vector, geometricMean_vector, averageGeometricMean] = mSQI(ecg, 1000);
        indexes{setIndex}{fileIndex} = geometricMean_vector;
        fprintf("Average mean of windows of %s: %f\n", currentFiles{fileIndex}, averageGeometricMean);
    end
end

indexes_topM = indexes{1};
indexes_topS = indexes{2};
indexes_topXS = indexes{3};



%significance level for calculating the confidence intervals
alph = 0.01;
%number of iterations to use in boostrap
iter = 1000;

% Data for the Comparison Within Each Register
% data of topM that will be used for the CI
data_topM_R2R3R4 =[indexes_topM{2},indexes_topM{3},indexes_topM{4}]; % data_topM_R2R3R4 -> R2:register2, R3:register3, R4:register of  of topM
data_topM_R1R3R4 =[indexes_topM{1},indexes_topM{3},indexes_topM{4}];
data_topM_R1R2R4 =[indexes_topM{1},indexes_topM{2},indexes_topM{4}];
data_topM_R1R2R3 =[indexes_topM{1},indexes_topM{2},indexes_topM{3}];

% data of topS that will be used for the CI
data_topS_R2R3R4 =[indexes_topS{2},indexes_topS{3},indexes_topS{4}]; % data_topS_R2R3R4 -> R2:register2, R3:register3, R4:register of topS
data_topS_R1R3R4 =[indexes_topS{1},indexes_topS{3},indexes_topS{4}];
data_topS_R1R2R4 =[indexes_topS{1},indexes_topS{2},indexes_topS{4}];
data_topS_R1R2R3 =[indexes_topS{1},indexes_topS{2},indexes_topS{3}];

% data of topXS that will be used for the CI
data_topXS_R2R3R4 =[indexes_topXS{2},indexes_topXS{3},indexes_topXS{4}]; % data_topS_R2R3R4 -> R2:register2, R3:register3, R4:register of topS
data_topXS_R1R3R4 =[indexes_topXS{1},indexes_topXS{3},indexes_topXS{4}];
data_topXS_R1R2R4 =[indexes_topXS{1},indexes_topXS{2},indexes_topXS{4}];
data_topXS_R1R2R3 =[indexes_topXS{1},indexes_topXS{2},indexes_topXS{3}];


% Data for the Comparison Across Registers
data_topMvstopS_topXS=cell2mat([indexes_topS,indexes_topXS]); % cell2mat-> convert the contents of a cell array into a single matrix
data_topSvstopM_topXS=cell2mat([indexes_topM,indexes_topXS]);
data_topXSvstopM_topS=cell2mat([indexes_topM,indexes_topS]);


%CONFIDENCE INTERVALS (CI)
% Comparison Within Each Register of TopM Data
%CI for R1 vs {R2, R3 y R4}
CIMedian_topM_R1vsR2R3R4 = estimateCIMedian(indexes_topM{1},data_topM_R2R3R4,alph,iter);
CIMean_topM_R1vsR2R3R4 = estimateCIMean(indexes_topM{1},data_topM_R2R3R4,alph,iter);
%CI for R2 vs {R1, R3 y R4}
CIMedian_topM_R2vsR1R3R4 = estimateCIMedian(indexes_topM{2},data_topM_R1R3R4,alph,iter);
CIMean_topM_R2vsR1R3R4 = estimateCIMean(indexes_topM{2},data_topM_R1R3R4,alph,iter);
%CI for R3 vs {R1, R2 y R4}
CIMedian_topM_R3vsR1R2R4 = estimateCIMedian(indexes_topM{3},data_topM_R1R2R4,alph,iter);
CIMean_topM_R3vsR1R2R4 = estimateCIMean(indexes_topM{3},data_topM_R1R2R4,alph,iter);
%CI for R4 vs {R1, R2 y R3}
CIMedian_topM_R4vsR1R2R3 = estimateCIMedian(indexes_topM{4},data_topM_R1R2R3,alph,iter);
CIMean_topM_R4vsR1R2R3 = estimateCIMean(indexes_topM{4},data_topM_R1R2R3,alph,iter);

% Comparison Within Each Register of TopS Data
%CI for R1 vs {R2, R3 y R4}
CIMedian_topS_R1vsR2R3R4 = estimateCIMedian(indexes_topS{1},data_topS_R2R3R4,alph,iter);
CIMean_topS_R1vsR2R3R4 = estimateCIMean(indexes_topS{1},data_topS_R2R3R4,alph,iter);
%CI for R2 vs {R1, R3 y R4}
CIMedian_topS_R2vsR1R3R4 = estimateCIMedian(indexes_topS{2},data_topS_R1R3R4,alph,iter);
CIMean_topS_R2vsR1R3R4 = estimateCIMean(indexes_topS{2},data_topS_R1R3R4,alph,iter);
%CI for R3 vs {R1, R2 y R4}
CIMedian_topS_R3vsR1R2R4 = estimateCIMedian(indexes_topS{3},data_topS_R1R2R4,alph,iter);
CIMean_topS_R3vsR1R2R4 = estimateCIMean(indexes_topS{3},data_topS_R1R2R4,alph,iter);
%CI for R4 vs {R1, R2 y R3}
CIMedian_topS_R4vsR1R2R3 = estimateCIMedian(indexes_topS{4},data_topS_R1R2R3,alph,iter);
CIMean_topS_R4vsR1R2R3 = estimateCIMean(indexes_topS{4},data_topS_R1R2R3,alph,iter);

% Comparison Within Each Register of TopXS Data
%CI for R1 vs {R2, R3 y R4}
CIMedian_topXS_R1vsR2R3R4 = estimateCIMedian(indexes_topXS{1},data_topXS_R2R3R4,alph,iter);
CIMean_topXS_R1vsR2R3R4 = estimateCIMean(indexes_topXS{1},data_topXS_R2R3R4,alph,iter);
%CI for R2 vs {R1, R3 y R4}
CIMedian_topXS_R2vsR1R3R4 = estimateCIMedian(indexes_topXS{2},data_topXS_R1R3R4,alph,iter);
CIMean_topXS_R2vsR1R3R4 = estimateCIMean(indexes_topXS{2},data_topXS_R1R3R4,alph,iter);
%CI for R3 vs {R1, R2 y R4}
CIMedian_topXS_R3vsR1R2R4 = estimateCIMedian(indexes_topXS{3},data_topXS_R1R2R4,alph,iter);
CIMean_topXS_R3vsR1R2R4 = estimateCIMean(indexes_topXS{3},data_topXS_R1R2R4,alph,iter);
%CI for R4 vs {R1, R2 y R3}
CIMedian_topXS_R4vsR1R2R3 = estimateCIMedian(indexes_topXS{4},data_topXS_R1R2R3,alph,iter);
CIMean_topXS_R4vsR1R2R3 = estimateCIMean(indexes_topXS{4},data_topXS_R1R2R3,alph,iter);


% Comparison of the first and last register of each top -> washing effect

% CI for TopM_R1 vs TopM_R4
CIMedian_TopM_R1vsTopM_R4 = estimateCIMedian(indexes_topM{1}, indexes_topM{4}, alph, iter);
CIMean_TopM_R1vsTopM_R4 = estimateCIMean(indexes_topM{1}, indexes_topM{4}, alph, iter);

% CI for TopS_R1 vs TopS_R4
CIMedian_TopS_R1vsTopS_R4 = estimateCIMedian(indexes_topS{1}, indexes_topS{4}, alph, iter);
CIMean_TopS_R1vsTopS_R4 = estimateCIMean(indexes_topS{1}, indexes_topS{4}, alph, iter);

% CI for TopXS_R1 vs TopXS_R4
CIMedian_TopXS_R1vsTopXS_R4 = estimateCIMedian(indexes_topXS{1}, indexes_topXS{4}, alph, iter);
CIMean_TopXS_R1vsTopXS_R4 = estimateCIMean(indexes_topXS{1}, indexes_topXS{4}, alph, iter);

% Preparar datos para la tabla
data = {
    'CIMedian_TopM_R1vsTopM_R4', sprintf('[%.4f, %.4f]', CIMedian_TopM_R1vsTopM_R4);
    'CIMean_TopM_R1vsTopM_R4', sprintf('[%.4f, %.4f]', CIMean_TopM_R1vsTopM_R4);
    'CIMedian_TopS_R1vsTopS_R4', sprintf('[%.4f, %.4f]', CIMedian_TopS_R1vsTopS_R4);
    'CIMean_TopS_R1vsTopS_R4', sprintf('[%.4f, %.4f]', CIMean_TopS_R1vsTopS_R4);
    'CIMedian_TopXS_R1vsTopXS_R4', sprintf('[%.4f, %.4f]', CIMedian_TopXS_R1vsTopXS_R4);
    'CIMean_TopXS_R1vsTopXS_R4', sprintf('[%.4f, %.4f]', CIMean_TopXS_R1vsTopXS_R4);
};

% Convertir los datos a una tabla
T = cell2table(data(:,2)', 'VariableNames', data(:,1)');

% Guardar la tabla en un archivo CSV
filename = 'washingEffect_CI.csv';
writetable(T, filename);



% Histograms for each register of TopM
for i = 1:4
    figure;
    histogram(indexes_topM{i}, 20);
    xlabel('mSQI Values');
    ylabel('count'); % ASK MAS INTERPRETACION
    title(['Histogram for indexes\_topM{' num2str(i) '}']);
end

% Histograms for each register of TopS
for i = 1:4
    figure;
    histogram(indexes_topS{i}, 20);
    xlabel('mSQI Values');
    ylabel('count');
    title(['Histogram for indexes\_topS{' num2str(i) '}']);
end

% Histograms for each register of TopXS
for i = 1:4
    figure;
    histogram(indexes_topXS{i}, 20);
    xlabel('mSQI Values');
    ylabel('count');
    title(['Histogram for indexes\_topXS{' num2str(i) '}']);
end

%histogram(indexes_topM{1}, 20)
%figure()
%histogram(geometricMean_V_24, 20)


indexes_topM_v = cell2mat(indexes_topM);
indexes_topS_v = cell2mat(indexes_topS);
indexes_topXS_v = cell2mat(indexes_topXS);

z_mean_indexes_topM = mean (indexes_topM_v);
z_var_indexes_topM = var(indexes_topM_v);
z_mean_indexes_topS = mean (indexes_topS_v);
z_var_indexes_topS = var(indexes_topS_v);
z_mean_indexes_topXS = mean (indexes_topXS_v);
z_var_indexes_topXS = var(indexes_topXS_v);


y_CIMedian_topMvstopS= estimateCIMedian(indexes_topM_v, indexes_topS_v, alph, iter);
y_CIMean_topMvstopS= estimateCIMean(indexes_topM_v, indexes_topS_v, alph, iter);

y_CIMedian_topMvstopXS= estimateCIMedian(indexes_topM_v, indexes_topXS_v, alph, iter);
y_CIMean_topMvstopXS= estimateCIMean(indexes_topM_v, indexes_topXS_v, alph, iter);

y_CIMedian_topSvstopXS= estimateCIMedian(indexes_topS_v, indexes_topXS_v, alph, iter);
y_CIMean_topSvstopXS= estimateCIMean(indexes_topS_v, indexes_topXS_v, alph, iter);


x_mean_indexes_topM = cellfun(@mean, indexes_topM);
x_mean_indexes_topS = cellfun(@mean, indexes_topS);
x_mean_indexes_topXS = cellfun(@mean, indexes_topXS);

x_var_indexes_topM = cellfun(@var, indexes_topM);
x_var_indexes_topS = cellfun(@var, indexes_topS);
x_var_indexes_topXS = cellfun(@var, indexes_topXS);

figure
histogram(indexes_topM_v, 20);
xlabel('mSQI Values');
ylabel('count');
title(['Histogram for indexes top M']);

figure
histogram(indexes_topS_v, 20);
xlabel('mSQI Values');
ylabel('count');
title(['Histogram for indexes top S']);

figure
histogram(indexes_topXS_v, 20);
xlabel('mSQI Values');
ylabel('count');
title(['Histogram for indexes top XS']);


tiledlayout(3,1)

nexttile
histogram(indexes_topM_v, 20);
xlabel('mSQI Values');
ylabel('count');
title(['Histogram for indexes top M']);

nexttile
histogram(indexes_topS_v, 20);
xlabel('mSQI Values');
ylabel('count');
title(['Histogram for indexes top S']);

nexttile
histogram(indexes_topXS_v, 20);
xlabel('mSQI Values');
ylabel('count');
title(['Histogram for indexes top XS']);



