clear all; 
close all; 
clc;

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
% 2. CONFIGURAÇÕES DOS DIAS
% =========================================================================
dias_escolhidos = [24]; % dia escolhido (nesse caso foi o dia do evento)
horas_por_dia = 1440; % 1440 pontos em um dia, porque é um dado por minuto (60 x 24)
num_total_dias = 31; % total de dias do mês em cada arquivo
teste = []; % matriz final onde serão salvos os dados de todas estações

% =========================================================================
% 3. LOOP DE PROCESSAMENTO
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

    % processamento TEC
    media = data(:, 1); % primeira coluna é a média
    vtec_data = data(:, 5:2:end); % pega as colunas de VTEC (entre os dias 1 a 31, e pulando de 2 em 2, porque uma coluna é de hora, e a outra é de TEC)
    
    % lineariza os 31 dias (transforma a matriz em um vetor coluna longo)
    % usa vtec_cols' (transposta) garante que o reshape siga a ordem dos dias corretamente
    vtec_data = [vtec_data(:,1); vtec_data(:,2); vtec_data(:,3); vtec_data(:,4); vtec_data(:,5); vtec_data(:,6);vtec_data(:,7); vtec_data(:,8); vtec_data(:,9); vtec_data(:,10);...
                 vtec_data(:,11); vtec_data(:,12); vtec_data(:,13); vtec_data(:,14); vtec_data(:,15); vtec_data(:,16);vtec_data(:,17); vtec_data(:,18); vtec_data(:,19); vtec_data(:,20);...
                 vtec_data(:,21); vtec_data(:,22); vtec_data(:,23); vtec_data(:,24); vtec_data(:,25); vtec_data(:,26);vtec_data(:,27); vtec_data(:,28); vtec_data(:,29); vtec_data(:,30);...
                 vtec_data(:,31)];
    
    % expande a média para bater com o tamanho dos 31 dias
    media_expand = repmat(media, num_total_dias, 1);

    % calcula a diferença do TEC em relação à média  
    diff_TEC = vtec_data - media_expand;
    
%     plot(vtec_data) % esse plot é apenas para verificar se o código está funcionando corretamente (porque se colocar reshape no vtec_data, dá errado)
%     return

    % extração dos dias escolhidos
    idx_final = [];
    
    % esse for vai calcular os índices do dia escolhido (nesse caso, o dia 22, por exemplo)
    for d = dias_escolhidos 
        inicio = (d-1)*horas_por_dia + 1;
        fim = d*horas_por_dia;
        idx_final = [idx_final inicio:fim]; 
    end

    % armazena apenas os dados dos dias selecionados na matriz final
    if length(diff_TEC) >= max(idx_final)
        teste(:, i) = diff_TEC(idx_final);
    else
        fprintf('Aviso: Arquivo %s tem menos dados que o esperado.\n', fileList{i});
    end
end

% =========================================================================
% 4. SALVAMENTO
% =========================================================================
output_folder = fullfile(selPath, 'dados formatados'); % cria uma pasta chamada "dados formatados" caso ela ainda não exista
if ~exist(output_folder, 'dir'), mkdir(output_folder); end

% cria o nome do arquivo que indica quais dias foram extraídos, por exemplo, "matrix_diffTEC_Aug2025_terremoto22"
dias_str = sprintf('%d_', dias_escolhidos);
output_name = ['matrix_diffTEC_Aug2011_terremoto', dias_str(1:end-1), '.txt'];
output_file = fullfile(output_folder, output_name);

writematrix(teste, output_file, 'Delimiter', ' '); % salva a matriz final em .txt

% imprime essas mensagens no command window quando acabar de processar os arquivos
fprintf('Processamento finalizado!'); 
fprintf('Arquivo salvo em: %s\n', output_file);