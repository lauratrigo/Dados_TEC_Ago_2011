clear all 
close all
clc

% =========================================================================
% 1. SELEÇÃO AUTOMÁTICA DA PASTA E ARQUIVOS
% =========================================================================
selPath = uigetdir(pwd, 'Selecione a pasta com os arquivos .txt das estações'); % abre uma janela no gerenciador de arquivos para o usuário escolher o caminho dos dados
if isequal(selPath, 0), return; end % se o usuário fechar a janela, o programa encerra aqui

% lista todos os arquivos .txt na pasta
fileData = dir(fullfile(selPath, '*.txt'));
fileList = {fileData.name};

% condicional para garantir que tenha pelo menos um arquivo na pasta
if isempty(fileList)
    error('Nenhum arquivo .txt encontrado na pasta selecionada.');
end

% =========================================================================
% CONFIGURAÇÕES DE TEMPO
% =========================================================================

num_days = 31; % número de dias no mês escolhido para análise (nesse caso, agosto de 2011)
hours_per_day = 24; % número de horas no dia

% =========================================================================
% LOOP PRINCIPAL (processa cada estação)
% =========================================================================

for i = 1:length(fileList)
    currentFile = fullfile(selPath, fileList{i}); % caminho completo do arquivo atual
    fileList{i} % printa o nome do arquivo no console
    fprintf('Processando arquivo %d de %d: %s\n', i, length(fileList), fileList{i}); % mensagem de atualização de qual arquivo está sendo processado naquele momento

    fid = fopen(currentFile, 'rt'); % abre o arquivo para leitura
    
    % condicional para se caso der problema no arquivo atual, pula para o próximo
    if fid == -1
        fprintf('Erro ao abrir: %s\n', fileList{i});
        continue
    end

    % ---------------------------------------------------------------------
    % TRATAMENTO DOS DADOS
    % ---------------------------------------------------------------------

    % lê o conteúdo do arquivo e pula o cabeçalho, lê linha por linha e pula a primeira
    raw_data = textscan(fid, '%s', 'Delimiter', '\n', 'HeaderLines', 1);
    fclose(fid);

    % tratamento de decimal e para valores inválidos
    clean_raw = strrep(raw_data{1}, ',', '.');
    clean_raw = strrep(clean_raw, '-999.0', 'NaN');

    % converte para matriz numérica
    try
        data = cell2mat(cellfun(@str2num, clean_raw, 'UniformOutput', false)); % converte de texto para número
    catch
        fprintf('Erro na conversão numérica do arquivo %s. Pulando.\n', fileList{i});
        continue;
    end
    
    % ---------------------------------------------------------------------
    % EXTRAÇÃO DAS VARIÁVEIS
    % ---------------------------------------------------------------------
    
    media = data(:, 1); % a coluna 1 é a da média
    
    [N, M] = size(media);
    
    % expande a média para bater com o tamanho dos 31 dias
    media = repmat(media, num_days, 1);
    
    med_plus = data(:, 2); % mediana + desvio 
    
    [N, M] = size(med_plus);

    % substituí NaN por média
    for j = 1:N
        if isnan(med_plus(j, 1))
            med_plus(j, 1) = media(j+1, 1);
            disp('NaN value replaced with media value');
        end
    end
    
    % expande para 31 dias
    med_plus = repmat(med_plus, num_days, 1);
    
    med_minus = data(:, 3); % mediana - desvio
    
    [N, M] = size(med_minus);
    
    % substituí NaN por média
    for j = 1:N
        if isnan(med_minus(j, 1))
            med_minus(j, 1) = media(j+1, 1);
            disp('NaN value replaced with media value');
        end
    end

    med_minus = repmat(med_minus, num_days, 1);
    
    % ---------------------------------------------------------------------
    % VTEC (dados principais)
    % ---------------------------------------------------------------------
    
    % processamento TEC
    vtec_data = data(:, 5:2:end); % pega as colunas de VTEC (entre os dias 1 a 31, e pulando de 2 em 2, porque uma coluna é de hora, e a outra é de TEC)
    [N, M] = size(vtec_data);
    
    % lineariza os 31 dias (transforma a matriz em um vetor coluna longo)
    % usa vtec_cols' (transposta) garante que o reshape siga a ordem dos dias corretamente
    vtec_data = [vtec_data(:,1); vtec_data(:,2); vtec_data(:,3); vtec_data(:,4); vtec_data(:,5); vtec_data(:,6);vtec_data(:,7); vtec_data(:,8); vtec_data(:,9); vtec_data(:,10);...
                 vtec_data(:,11); vtec_data(:,12); vtec_data(:,13); vtec_data(:,14); vtec_data(:,15); vtec_data(:,16);vtec_data(:,17); vtec_data(:,18); vtec_data(:,19); vtec_data(:,20);...
                 vtec_data(:,21); vtec_data(:,22); vtec_data(:,23); vtec_data(:,24); vtec_data(:,25); vtec_data(:,26);vtec_data(:,27); vtec_data(:,28); vtec_data(:,29); vtec_data(:,30);...
                 vtec_data(:,31)];
    
    % ---------------------------------------------------------------------
    % CÁLCULO PRINCIPAL
    % ---------------------------------------------------------------------
      
    % calcula a diferença do TEC em relação à média  
    diff_TEC = vtec_data - media;
    
%     plot(vtec_data) % esse plot é apenas para verificar se o código está funcionando corretamente (porque se colocar reshape no vtec_data, dá errado)
%     
%     return
    
    % guarda cada estação como uma coluna    
    teste(:,i)=diff_TEC; 
    
    disp('O programa terminou de rodar e todos os arquivos foram salvos com sucesso!');
end

% =========================================================================
% SALVAMENTO FINAL
% =========================================================================

output_folder = fullfile(selPath, 'dados formatados'); % cria uma pasta chamada "dados formatados" caso ela ainda não exista
if ~exist(output_folder, 'dir'), mkdir(output_folder); end

% salva a matriz final em .txt
output_file = fullfile(output_folder, 'matrix_diffTECAug2011.txt');
writematrix(teste, output_file, 'Delimiter', ' ');

% imprime essas mensagens no command window quando acabar de processar os arquivos
disp(['Arquivo salvo em: ', output_file]);
disp('O programa terminou de rodar e todos os arquivos foram salvos com sucesso!');
