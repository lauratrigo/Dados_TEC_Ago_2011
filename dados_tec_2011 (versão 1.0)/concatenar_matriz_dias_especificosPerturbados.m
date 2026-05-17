clear all
close all
clc

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

dias_escolhidos = [5 6 14 15 23];
horas_por_dia = 1440;

for i = 1:length(files)

    fid = fopen(files{i}, 'rt');
    raw_data = textscan(fid, '%s', 'Delimiter', '\n', 'HeaderLines', 1);
    fclose(fid);

    fprintf('Processando %s\n', files{i});

    % Corrigir decimal
    for j = 1:length(raw_data{1})
        raw_data{1}{j} = strrep(raw_data{1}{j}, ',', '.');
        raw_data{1}{j} = strrep(raw_data{1}{j}, '-999.0', 'NaN');
    end

    data = cellfun(@str2num, raw_data{1}, 'UniformOutput', false);
    data = cell2mat(data);

    % ===============================
    % MÉDIA
    % ===============================
    media = data(:,1);

    % ===============================
    % VTEC (31 dias)
    % ===============================
    vtec_data = data(:,5:2:end);   % 31 colunas (dias)
    
    % Transformar em vetor 744x1
    vtec_data = reshape(vtec_data', [], 1);

    % Expandir média para 31 dias
    media_expand = repmat(media, 31, 1);

    % ===============================
    % DIFERENÇA
    % ===============================
    diff_TEC = vtec_data - media_expand;
    
    % ===============================
    % AGORA EXTRAÍMOS SÓ OS DIAS DESEJADOS
    % ===============================
    idx_final = [];

    for d = dias_escolhidos
        inicio = (d-1)*horas_por_dia + 1;
        fim = d*horas_por_dia;
        idx_final = [idx_final inicio:fim];
    end

    diff_TEC_selecionado = diff_TEC(idx_final);

    teste(:,i) = diff_TEC_selecionado;

end

% ===============================
% SALVAR
% ===============================
output_folder = 'C:\Users\vikla\Downloads\dados_tec_2011\formatado\';

if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

output_file = fullfile(output_folder, 'matrix_diffTEC_Aug2011_dias_perturbados.txt');
writematrix(teste, output_file, 'Delimiter',' ');

disp('Processamento finalizado com sucesso!')
