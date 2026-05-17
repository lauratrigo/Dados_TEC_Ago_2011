clear all
close all
clc

% =========================================================================
% LISTA DE ARQUIVOS (estações)
% =========================================================================

% lista com todos os arquivos .txt de cada estação de GNSS
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

% nome das estações de cada um dos arquivos que estão sendo importados (tem que escrever o nome das estações aqui na mesma ordem que os arquivos estão sendo importados)
stations = {'ALAR', 'BAIR', 'BATF', 'BAVC', 'BELE', 'BOAV', 'BRAZ', 'BRFT', 'CEEU', 'CEFE', 'CEFT', 'CHPI', 'CUIB', 'GOJA', 'ILHA', 'IMBT', 'IMPZ', 'MABA', ...
    'MGBH', 'MGIN', 'MGMC', 'MGRP', 'MGUB', 'MSCG', 'MTCN', 'MTCO', 'MTSF', 'MTSR', 'NAUS', 'NEIA', 'ONRJ', 'PAIT', 'PBCG', 'PEPE', 'PISR', 'PITN', 'POAL', ...
    'POLI', 'POVE', 'PPTE', 'PRGU', 'PRMA', 'RIOB', 'RIOD', 'RJCG', 'RNMO', 'RNNA', 'ROCD', 'ROGM', 'ROJI', 'ROSA', 'SAGA', 'SALU', 'SAVO', 'SCCH', 'SCLA', ...
    'SJRP', 'SMAR', 'SPAR', 'SSA1', 'TOGU', 'TOPL', 'UFPR', 'VICO'};

% =========================================================================
% 2. CONFIGURAÇÕES DOS DIAS
% =========================================================================

dias_escolhidos = [24]; % número de dias no mês escolhido para análise (neste caso, o dia 24)
horas_por_dia = 1440; % 1440 pontos em um dia, porque é um dado por minuto (60 x 24)

% =========================================================================
% LOOP PRINCIPAL (processa cada estação)
% =========================================================================

for i = 1:length(files)

    fid = fopen(files{i}, 'rt');  % abre arquivo por arquivo
    fprintf('Processando arquivo %d de %d: %s\n', i, length(files), files{i});

    % verifica se o arquivo existe
    if ~isfile(files{i})
        fprintf('Arquivo faltando: %s\n', files{i});
        continue
    end

    % verifica se abriu corretamente
    if fid == -1
        fprintf('Erro ao abrir: %s\n', files{i});
        continue
    end

    % agora sim lê o arquivo
    raw_data = textscan(fid, '%s', 'Delimiter', '\n', 'HeaderLines', 1);
    fclose(fid);
    
    % ---------------------------------------------------------------------
    % TRATAMENTO DOS DADOS
    % ---------------------------------------------------------------------

    % troca as vírgulas por pontos e substituí valores inválidos por NaN
    for j = 1:length(raw_data{1})
        raw_data{1}{j} = strrep(raw_data{1}{j}, ',', '.');
        raw_data{1}{j} = strrep(raw_data{1}{j}, '-999.0', 'NaN');
    end
    
    % converte texto para número
    data = cellfun(@str2num, raw_data{1}, 'UniformOutput', false);
    data = cell2mat(data);

    % ---------------------------------------------------------------------
    % EXTRAÇÃO DAS VARIÁVEIS
    % ---------------------------------------------------------------------
    
    media = data(:,1); % a coluna 1 é a da média

    vtec_data = data(:,5:2:end);  % pega as colunas de VTEC (entre os dias 1 a 31, e pulando de 2 em 2, porque uma coluna é de hora, e a outra é de TEC)
    
    % expande a média para bater com o tamanho dos 31 dias
    media_expand = repmat(media, 31, 1);

    % lineariza os 31 dias (transforma a matriz em um vetor coluna longo)
    % usa vtec_cols' (transposta) garante que o reshape siga a ordem dos dias corretamente
    vtec_data = [vtec_data(:,1); vtec_data(:,2); vtec_data(:,3); vtec_data(:,4); vtec_data(:,5); vtec_data(:,6);vtec_data(:,7); vtec_data(:,8); vtec_data(:,9); vtec_data(:,10);...
                 vtec_data(:,11); vtec_data(:,12); vtec_data(:,13); vtec_data(:,14); vtec_data(:,15); vtec_data(:,16);vtec_data(:,17); vtec_data(:,18); vtec_data(:,19); vtec_data(:,20);...
                 vtec_data(:,21); vtec_data(:,22); vtec_data(:,23); vtec_data(:,24); vtec_data(:,25); vtec_data(:,26);vtec_data(:,27); vtec_data(:,28); vtec_data(:,29); vtec_data(:,30);...
                 vtec_data(:,31)];
             
    % ===============================
    % CÁLCULO PRINCIPAL
    % ===============================
    diff_TEC = vtec_data - media_expand;
    
%     plot(vtec_data) % esse plot é apenas para verificar se o código está funcionando corretamente (porque se colocar reshape no vtec_data, dá errado)
%     return
    
    % extração dos dias escolhidos
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

% cria uma pasta no caminho indicado para o usuário, caso ela ainda não exista
output_folder = 'C:\Users\vikla\Downloads\dados_tec_2011\dados formatados\';

if ~exist(output_folder, 'dir')
    mkdir(output_folder);
end

% salva a matriz final em .txt
output_file = fullfile(output_folder, 'matrix_diffTEC_Aug2011_dias_perturbados.txt');
writematrix(teste, output_file, 'Delimiter',' ');

disp('Processamento finalizado com sucesso!')
