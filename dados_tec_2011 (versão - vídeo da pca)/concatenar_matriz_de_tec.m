clear all 
close all
clc
%teste=zeros(44640,1);
% List of files corresponding to each station
%  files = {'IMPZ-2011-08(01-31).txt','VICO-2011-08(01-31).txt'};
%  stations = {'IMPZ','VICO'};
% Lista de estações
% files = {'ALAR-2011-08(01-31).txt', 'BAIR-2011-08(01-31).txt'};


files = {'ALAR-2011-08(01-31).txt', 'BAIR-2011-08(01-31).txt', 'BATF-2011-08(01-31).txt', 'BAVC-2011-08(01-31).txt', 'BELE-2011-08(01-31).txt', 'BOAV-2011-08(01-31).txt', ...
    'BRAZ-2011-08(01-31).txt', 'BRFT-2011-08(01-31).txt', 'CEEU-2011-08(01-31).txt', 'CEFE-2011-08(01-31).txt', 'CEFT-2011-08(01-31).txt', 'CHPI-2011-08(01-31).txt', ...
    'CUIB-2011-08(01-31).txt', 'GOJA-2011-08(01-31).txt', 'ILHA-2011-08(01-31).txt', 'IMBT-2011-08(01-31).txt', 'IMPZ-2011-08(01-31).txt', 'MABA-2011-08(01-31).txt', ...
    'MGBH-2011-08(01-31).txt', 'MGIN-2011-08(01-31).txt', 'MGMC-2011-08(01-31).txt', 'MGRP-2011-08(01-31).txt', 'MGUB-2011-08(01-31).txt', 'MSCG-2011-08(01-31).txt', ...
    'MTCN-2011-08(01-31).txt', 'MTCO-2011-08(01-31).txt', 'MTSF-2011-08(01-31).txt', 'MTSR-2011-08(01-31).txt', 'NAUS-2011-08(01-31).txt', 'NEIA-2011-08(01-31).txt', ...
    'ONRJ-2011-08(01-31).txt', 'PAIT-2011-08(01-31).txt', 'PBCG-2011-08(01-31).txt', 'PEPE-2011-08(01-31).txt', 'PISR-2011-08(01-31).txt', 'PITN-2011-08(01-31).txt', ...
    'POAL-2011-08(01-31).txt', 'POLI-2011-08(01-31).txt', 'POVE-2011-08(01-31).txt', 'PPTE-2011-08(01-31).txt', 'PRGU-2011-08(01-31).txt', 'PRMA-2011-08(01-31).txt', ...
    'RIOB-2011-08(01-31).txt', 'RIOD-2011-08(01-31).txt', 'RJCG-2011-08(01-31).txt', 'RNMO-2011-08(01-31).txt', 'RNNA-2011-08(01-31).txt', 'ROCD-2011-08(01-31).txt', ...
    'ROGM-2011-08(01-31).txt', 'ROJI-2011-08(01-31).txt', 'ROSA-2011-08(01-31).txt', 'SAGA-2011-08(01-31).txt', 'SALU-2011-08(01-31).txt', 'SAVO-2011-08(01-31).txt', ...
    'SCCH-2011-08(01-31).txt', 'SCLA-2011-08(01-31).txt', 'SJRP-2011-08(01-31).txt', 'SMAR-2011-08(01-31).txt', 'SPAR-2011-08(01-31).txt', 'SSA1-2011-08(01-31).txt', ...
    'TOGU-2011-08(01-31).txt', 'TOPL-2011-08(01-31).txt', 'UFPR-2011-08(01-31).txt', 'VICO-2011-08(01-31).txt'};

stations = {'ALAR', 'BAIR', 'BATF', 'BAVC', 'BELE', 'BOAV', 'BRAZ', 'BRFT', 'CEEU', 'CEFE', 'CEFT', 'CHPI', 'CUIB', 'GOJA', 'ILHA', 'IMBT', 'IMPZ', 'MABA', ...
    'MGBH', 'MGIN', 'MGMC', 'MGRP', 'MGUB', 'MSCG', 'MTCN', 'MTCO', 'MTSF', 'MTSR', 'NAUS', 'NEIA', 'ONRJ', 'PAIT', 'PBCG', 'PEPE', 'PISR', 'PITN', 'POAL', ...
    'POLI', 'POVE', 'PPTE', 'PRGU', 'PRMA', 'RIOB', 'RIOD', 'RJCG', 'RNMO', 'RNNA', 'ROCD', 'ROGM', 'ROJI', 'ROSA', 'SAGA', 'SALU', 'SAVO', 'SCCH', 'SCLA', ...
    'SJRP', 'SMAR', 'SPAR', 'SSA1', 'TOGU', 'TOPL', 'UFPR', 'VICO'};

% Initialize figure
% figure;
% hold on;

% Number of days and hours per day
num_days = 31; % From 12 to 23 of October
hours_per_day = 24; % Hours per day

% Define major ticks
% major_ticks = datenum(2011, 8, 1):datenum(2011, 9, 1); % Major ticks from October 12th to 23rd


% Calculate minor ticks: three minor ticks between each major tick
% minor_ticks = [];
% for k = 1:length(major_ticks)-1
%     minor_ticks = [minor_ticks, linspace(major_ticks(k), major_ticks(k+1), 5)]; % Divide each day into 4 (3 intervals)
% end
% minor_ticks = setdiff(minor_ticks, major_ticks); % Remove the major ticks to keep only minor

% Loop through each station and file
for i = 1:length(files)
    % Read data as text, skipping the first line
    fid = fopen(files{i}, 'rt');
    raw_data = textscan(fid, '%s', 'Delimiter', '\n', 'HeaderLines', 1);
    fclose(fid);
    
    fprintf('Processando arquivo %d de %d: %s\n', i, length(files), files{i});

    % Convert commas to dots for decimal points
    for j = 1:length(raw_data{1})
        raw_data{1}{j} = strrep(raw_data{1}{j}, ',', '.');
    end
    
    % Convert '-999.0' to NaN
    for j = 1:length(raw_data{1})
        raw_data{1}{j} = strrep(raw_data{1}{j}, '-999.0', 'NaN');
    end
    
    % Convert text data to numeric data
    data = cellfun(@(x) str2num(x), raw_data{1}, 'UniformOutput', false);
    data = cell2mat(data);
    


    % Extract relevant data
    media = data(:, 1); % Media (Average)
    [N, M] = size(media);
    media = repmat(media, num_days, 1);
    
    med_plus = data(:, 2); % Median + Deviation
    [N, M] = size(med_plus);

    % Replace NaNs in med_plus
    for j = 1:N
        if isnan(med_plus(j, 1))
            med_plus(j, 1) = media(j+1, 1);
            disp('NaN value replaced with media value');
        end
    end

    med_plus = repmat(med_plus, num_days, 1);
    med_minus = data(:, 3); % Median - Deviation
    [N, M] = size(med_minus);
    
    % Replace NaNs in med_minus
    for j = 1:N
        if isnan(med_minus(j, 1))
            med_minus(j, 1) = media(j+1, 1);
            disp('NaN value replaced with media value');
        end
    end

    med_minus = repmat(med_minus, num_days, 1);
    
    % Reshape VTEC data to 24 hours format
    vtec_data = data(:, 5:2:end); % VTEC data every 2 columns starting from column 5
    [N, M] = size(vtec_data);
    
    vtec_data = [vtec_data(:,1); vtec_data(:,2); vtec_data(:,3); vtec_data(:,4); vtec_data(:,5); vtec_data(:,6);vtec_data(:,7); vtec_data(:,8); vtec_data(:,9); vtec_data(:,10);...
                 vtec_data(:,11); vtec_data(:,12); vtec_data(:,13); vtec_data(:,14); vtec_data(:,15); vtec_data(:,16);vtec_data(:,17); vtec_data(:,18); vtec_data(:,19); vtec_data(:,20);...
                 vtec_data(:,21); vtec_data(:,22); vtec_data(:,23); vtec_data(:,24); vtec_data(:,25); vtec_data(:,26);vtec_data(:,27); vtec_data(:,28); vtec_data(:,29); vtec_data(:,30);...
                 vtec_data(:,31)];
   
   
        

    diff_TEC = vtec_data - media;
    
    teste(:,i)=diff_TEC;
    
       
   
    

disp('O programa terminou de rodar e todos os arquivos foram salvos com sucesso!');

end

% Pasta onde salvar
output_folder = 'C:\Users\vikla\Downloads\dados_tec_2011\formatado\';
if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% Salva todo o teste de uma vez
output_file = fullfile(output_folder, 'matrix_diffTECAug2011.txt');
writematrix(teste, output_file, 'Delimiter', ' ');

disp(['Arquivo salvo em: ', output_file]);
disp('O programa terminou de rodar e todos os arquivos foram salvos com sucesso!');




