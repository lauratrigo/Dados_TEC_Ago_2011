clear; close all; clc;

% -------------------------
% Coordenadas [latitude longitude]
% -------------------------
coords = [
   -9.749  -36.653;   -11.306  -41.859;   -17.555  -39.743;   -14.888  -40.803;
   -1.409  -48.463;     2.845  -60.701;   -15.947  -47.878;   -3.877  -38.426;
   -3.878  -38.426;   -20.311  -40.319;   -3.711  -38.473;   -22.687  -44.985;
  -15.555  -56.070;   -17.883  -51.726;   -20.428  -51.343;   -28.235  -48.656;
   -5.492  -47.497;    -5.362  -49.122;   -19.942  -43.925;   -22.319  -46.328;
  -16.716  -43.858;   -19.210  -46.133;   -18.919  -48.256;   -20.441  -54.541;
  -13.556  -52.271;   -10.804  -55.456;   -11.619  -50.664;   -12.545  -55.727;
   -3.023  -60.055;   -25.020  -47.925;   -22.896  -43.224;    -4.288  -56.036;
   -7.214  -35.907;    -9.384  -40.506;    -9.031  -42.703;    -5.102  -42.793;
  -30.074  -51.120;   -22.318  -44.327;    -8.709  -63.896;   -22.120  -51.409;
  -25.384  -51.488;   -23.410  -51.938;    -9.965  -67.803;   -22.818  -43.306;
  -21.765  -41.326;    -5.204  -37.325;    -5.836  -35.208;   -13.122  -60.544;
  -10.784  -65.331;   -10.864  -61.960;   -22.523  -52.952;    -0.144  -67.058;
  -12.975  -38.516;   -12.939  -38.432;   -27.138  -52.600;   -27.793  -50.304;
  -20.786  -49.360;   -29.719  -53.717;   -21.185  -40.440;   -12.975  -38.516;
  -11.747  -49.049;   -10.171  -48.331;   -25.448  -49.231;   -20.762  -42.870;
];

lat = coords(:,1);
lon = coords(:,2);

names = {'ALAR','BAIR','BATF','BAVC','BELE','BOAV','BRAZ','BRFT',...
         'CEEU','CEFE','CEFT','CHPI','CUIB','GOJA','ILHA','IMBT',...
         'IMPZ','MABA','MGBH','MGIN','MGMC','MGRP','MGUB','MSCG',...
         'MTCN','MTCO','MTSF','MTSR','NAUS','NEIA','ONRJ','PAIT',...
         'PBCG','PEPE','PISR','PITN','POAL','POLI','POVE','PPTE',...
         'PRGU','PRMA','RIOB','RIOD','RJCG','RNMO','RNNA','ROCD',...
         'ROGM','ROJI','ROSA','SAGA','SALU','SAVO','SCCH','SCLA',...
         'SJRP','SMAR','SPAR','SSA1','TOGU','TOPL','UFPR','VICO'};
     
% REMOVER ESTAÇÕES
idx_remove = ismember(names, {'MTCN','MGUB','CEEU'});
lat(idx_remove) = [];
lon(idx_remove) = [];
names(idx_remove) = [];

% -------------------------
% CARREGAR DADOS E PCA
% -------------------------
matrix_list = readmatrix('matrix_diffTEC_Aug2011.txt');
matrix_list(isnan(matrix_list)) = 0;
matrix_list(:, idx_remove) = [];

[coeff,~,~,~,~] = pca(matrix_list,'Algorithm','als','Centered',true);
eof1 = coeff(:,4);

% Valores extremas de referência para o rebatimento
max_lon = max(lon);
min_lon = min(lon);
max_lat = max(lat);
min_lat = min(lat);

offset = 10; % Deslocamento em graus configurado no seu script original

% -------------------------
% EQUAÇÕES DE SIMETRIZAÇÃO (Construção da Matriz 3x3)
% -------------------------
lat_s{1} = lat;                                 lon_s{1} = lon;                             % Centro
lat_s{2} = lat;                                 lon_s{2} = 2*max_lon - lon + offset;        % Leste
lat_s{3} = lat;                                 lon_s{3} = 2*min_lon - lon - offset;        % Oeste
lat_s{4} = 2*max_lat - lat + offset;            lon_s{4} = lon;                             % Norte
lat_s{5} = 2*min_lat - lat - offset;            lon_s{5} = lon;                             % Sul
lat_s{6} = 2*max_lat - lat + offset;            lon_s{6} = 2*max_lon - lon + offset;        % Nordeste
lat_s{7} = 2*max_lat - lat + offset;            lon_s{7} = 2*min_lon - lon - offset;        % Noroeste
lat_s{8} = 2*min_lat - lat - offset;            lon_s{8} = 2*max_lon - lon + offset;        % Sudeste
lat_s{9} = 2*min_lat - lat - offset;            lon_s{9} = 2*min_lon - lon - offset;        % Sudoeste

% Unificação de dados para malha interpolada
lat_all = []; lon_all = []; eof_all = [];
for i = 1:9
    lat_all = [lat_all; lat_s{i}];
    lon_all = [lon_all; lon_s{i}];
    eof_all = [eof_all; eof1]; 
end

% -------------------------
% GRADE DE INTERPOLAÇÃO AMPLIADA
% -------------------------
lon_vec = linspace(min(lon_all)-5, max(lon_all)+5, 1000);
lat_vec = linspace(min(lat_all)-5, max(lat_all)+5, 1000);
[Lon, Lat] = meshgrid(lon_vec, lat_vec);

Z = griddata(lon_all, lat_all, eof_all, Lon, Lat, 'natural');

% -------------------------
% PLOT EXPLICATIVO PARA O TCC
% -------------------------
figure('Color',[1 1 1], 'Position', [100 100 950 750]);
contourf(Lon, Lat, Z, 100, 'LineColor','none');
colorbar; colormap(jet);
hold on;

% Lista de shapefiles utilizados no seu domínio de estudo
shapefiles = {'ar.shp', 'BR_UF_2019.shp', 'cl.shp', 'uy.shp'};

% Renderização dos mapas reais e rebatidos
for i = 1:length(shapefiles)
    try
        S = shaperead(shapefiles{i}, 'UseGeoCoords', true);
        
        for k = 1:length(S)
            X = S(k).Lon;
            Y = S(k).Lat;
            
            % 1. Domínio Central Real
            plot(X, Y, 'k', 'LineWidth', 2); 
            
            % 2. Rebatimento Leste
            plot(2*max_lon - X + offset, Y, 'k', 'LineWidth', 1.5);
            
            % 3. Rebatimento Oeste
            plot(2*min_lon - X - offset, Y, 'k', 'LineWidth', 1.5);
            
            % 4. Rebatimento Norte
            plot(X, 2*max_lat - Y + offset, 'k', 'LineWidth', 1.5);
            
            % 5. Rebatimento Sul
            plot(X, 2*min_lat - Y - offset, 'k', 'LineWidth', 1.5);
            
            % 6. Rebatimento Nordeste
            plot(2*max_lon - X + offset, 2*max_lat - Y + offset, 'k', 'LineWidth', 1.5);
            
            % 7. Rebatimento Noroeste
            plot(2*min_lon - X - offset, 2*max_lat - Y + offset, 'k', 'LineWidth', 1.5);
            
            % 8. Rebatimento Sudeste
            plot(2*max_lon - X + offset, 2*min_lat - Y - offset, 'k', 'LineWidth', 1.5);
            
            % 9. Rebatimento Sudoeste
            plot(2*min_lon - X - offset, 2*min_lat - Y - offset, 'k', 'LineWidth', 1.5);
        end
    catch
        fprintf('Aviso: Não foi possível processar geometrias do arquivo %s\n', shapefiles{i});
    end
end

% Plotagem homogênea de todas as estações (Reais e Artificiais identicas)
scatter(lon_all, lat_all, 25, 'k', 'filled');

% Limites dinâmicos baseados no limite total gerado pelo rebatimento macro
xlim([min(lon_all)-5, max(lon_all)+5])
ylim([min(lat_all)-5, max(lat_all)+5])

% Configurações estéticas exigidas pelas normas acadêmicas
xlabel('Longitude (°)')
ylabel('Latitude (°)')
title('Esquema de Simetrização de Fronteiras da América do Sul (Estrutura 3x3)')
grid on;
daspect([1 1 1]);

hold off;

% Exportação em alta definição sem artefatos de redimensionamento
print(gcf, 'Esquema_Simetrizacao_Macro_AmSul.png', '-dpng', '-r300');