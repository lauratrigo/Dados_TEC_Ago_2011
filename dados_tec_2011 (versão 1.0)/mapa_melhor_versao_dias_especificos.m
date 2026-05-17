clear; close all; clc;

% -------------------------
% Coordenadas [latitude longitude]
% -------------------------
coords = [
   -9.749  -36.653;   % ALAR
  -11.306  -41.859;   % BAIR
  -17.555  -39.743;   % BATF
  -14.888  -40.803;   % BAVC
   -1.409  -48.463;   % BELE
    2.845  -60.701;   % BOAV
  -15.947  -47.878;   % BRAZ
   -3.877  -38.426;   % BRFT
   -3.878  -38.426;   % CEEU
  -20.311  -40.319;   % CEFE
   -3.711  -38.473;   % CEFT
  -22.687  -44.985;   % CHPI
  -15.555  -56.070;   % CUIB
  -17.883  -51.726;   % GOJA
  -20.428  -51.343;   % ILHA
  -28.235  -48.656;   % IMBT
   -5.492  -47.497;   % IMPZ
   -5.362  -49.122;   % MABA
  -19.942  -43.925;   % MGBH
  -22.319  -46.328;   % MGIN
  -16.716  -43.858;   % MGMC
  -19.210  -46.133;   % MGRP
  -18.919  -48.256;   % MGUB
  -20.441  -54.541;   % MSCG
  -13.556  -52.271;   % MTCN
  -10.804  -55.456;   % MTCO
  -11.619  -50.664;   % MTSF
  -12.545  -55.727;   % MTSR
   -3.023  -60.055;   % NAUS
  -25.020  -47.925;   % NEIA
  -22.896  -43.224;   % ONRJ
   -4.288  -56.036;   % PAIT
   -7.214  -35.907;   % PBCG
   -9.384  -40.506;   % PEPE
   -9.031  -42.703;   % PISR
   -5.102  -42.793;   % PITN
  -30.074  -51.120;   % POAL
  -22.318  -44.327;   % POLI
   -8.709  -63.896;   % POVE
  -22.120  -51.409;   % PPTE
  -25.384  -51.488;   % PRGU
  -23.410  -51.938;   % PRMA
   -9.965  -67.803;   % RIOB
  -22.818  -43.306;   % RIOD
  -21.765  -41.326;   % RJCG
   -5.204  -37.325;   % RNMO
   -5.836  -35.208;   % RNNA
  -13.122  -60.544;   % ROCD
  -10.784  -65.331;   % ROGM
  -10.864  -61.960;   % ROJI
  -22.523  -52.952;   % ROSA
   -0.144  -67.058;   % SAGA
  -12.975  -38.516;   % SALU
  -12.939  -38.432;   % SAVO
  -27.138  -52.600;   % SCCH
  -27.793  -50.304;   % SCLA
  -20.786  -49.360;   % SJRP
  -29.719  -53.717;   % SMAR
  -21.185  -50.440;   % SPAR
  -12.975  -38.516;   % SSA1
  -11.747  -49.049;   % TOGU
  -10.171  -48.331;   % TOPL
  -25.448  -49.231;   % UFPR
  -20.762  -42.870;   % VICO
];

lat = coords(:,1);
lon = coords(:,2);

% -------------------------
% Nomes das estações
% -------------------------
names = {'ALAR','BAIR','BATF','BAVC','BELE','BOAV','BRAZ','BRFT',...
         'CEEU','CEFE','CEFT','CHPI','CUIB','GOJA','ILHA','IMBT',...
         'IMPZ','MABA','MGBH','MGIN','MGMC','MGRP','MGUB','MSCG',...
         'MTCN','MTCO','MTSF','MTSR','NAUS','NEIA','ONRJ','PAIT',...
         'PBCG','PEPE','PISR','PITN','POAL','POLI','POVE','PPTE',...
         'PRGU','PRMA','RIOB','RIOD','RJCG','RNMO','RNNA','ROCD',...
         'ROGM','ROJI','ROSA','SAGA','SALU','SAVO','SCCH','SCLA',...
         'SJRP','SMAR','SPAR','SSA1','TOGU','TOPL','UFPR','VICO'};
     

% REMOVER ESTAÇÕES MTCN e MGUR
% -------------------------
idx_remove = ismember(names, {'MTCN','MGUB','CEEU'});

lat(idx_remove) = [];
lon(idx_remove) = [];
names(idx_remove) = [];

% -------------------------
% CARREGAR DADOS
% -------------------------
matrix_list = readmatrix('matrix_diffTEC_Aug2011_dias_calmos.txt');

matrix_list(isnan(matrix_list)) = 0;

% Remover as mesmas estações da matriz
matrix_list(:, idx_remove) = [];

[coeff,score,latent,tsquared,explained] = pca(matrix_list);

%[coeff,score,latent,tsquared,explained] = pca(matrix_list,'Algorithm','als','Centered',true);

eof1 = coeff(:,1);

% eof1(idx_remove) = [];

pca1 = score(:,1)*coeff(:,1)';


% -------------------------
% SIMETRIZAÇÃO EM LATITUDE
% -------------------------

% CENTER
lat_sym1 = lat;
lon_sym1 = lon;
eof_sym1 = eof1;

% RIGHT
lat_sym2 = lat;
lon_sym2 = (abs(lon))+2*max(lon);
eof_sym2 = eof1;

% TOP CENTER
lat_sym3 = abs(lat);
lon_sym3 = (lon);
eof_sym3 = eof1;

% TOP RIGHT
lat_sym4 = abs(lat);
lon_sym4 = abs(lon)+2*max(lon);
eof_sym4 = eof1;

% BOTTOM CENTER 
lat_sym5 = lat;
lon_sym5 = (abs(lon))+2*min(lon);
eof_sym5 = eof1;

% LEFT
lat_sym6 = abs(lat)+2*min(lat);
lon_sym6 = (lon);
eof_sym6 = eof1;

% BOTTOM RIGHT 
lat_sym7 = abs(lat) + 2*min(lat);
lon_sym7 = abs(lon) + 2*max(lon);
eof_sym7 = eof1;

% TOP LEFT
lat_sym8 = abs(lat);
lon_sym8 = (abs(lon))+2*min(lon);
eof_sym8 = eof1;

% BOTTOM LEFT
lat_sym9 = abs(lat) + 2*min(lat);
lon_sym9 = (abs(lon))+2*min(lon);
eof_sym9 = eof1;


lat_all = [lat_sym1;lat_sym2;lat_sym3;lat_sym4;lat_sym5;lat_sym6;lat_sym7;lat_sym8;lat_sym9];
lon_all = [lon_sym1;lon_sym2;lon_sym3;lon_sym4;lon_sym5;lon_sym6;lon_sym7;lon_sym8;lon_sym9];
eof_all = [eof_sym1;eof_sym2;eof_sym3;eof_sym4;eof_sym5;eof_sym6;eof_sym7;eof_sym8;eof_sym9];



 
 
%  %PLOT TOP CENTER
% lat_sym1 = -lat;
% lon_sym1 = lon;
% eof_sym1 = eof1;

% %PLOT BOTTOM CENTER
% lat_sym2 = -lat+2*min(lat);
% lon_sym2 = lon;
% eof_sym2 = eof1;
% 
% %PLOT LEFT
% lat_sym3 = -lat;
% lon_sym3 = -(lon);
% eof_sym3 = eof1;
% 
% %PLOT RIGHT
% lat_sym4 = lat;
% lon_sym4 = -lon+2*min(lon);
% eof_sym4 = eof1;
% 
% 
% lat_sym5 = lat;
% lon_sym5 = -lon;
% eof_sym5 = eof1;
% 
% %PLOT BOTTOM CENTER
% lat_sym6 = lat;
% lon_sym6 = -(lon-2*min(lon));
% eof_sym6 = eof1;
% 
% 
% 
% lat_all = [lat; lat_sym1; lat_sym2; lat_sym3; lat_sym4; lat_sym5; lat_sym6];
% lon_all = [lon; lon_sym1; lon_sym2; lon_sym3; lon_sym4; lon_sym5; lon_sym6];
% eof_all = [eof1; eof_sym1; eof_sym2; eof_sym3; eof_sym4; eof_sym5; eof_sym6];


% -------------------------
% GRADE DE INTERPOLAÇÃO
% -------------------------
lon_vec = linspace(min(lon_all)-1, max(lon_all)+1, 400);
lat_vec = linspace(min(lat_all)-1, max(lat_all)+1, 400);
[Lon, Lat] = meshgrid(lon_vec, lat_vec);

Z = griddata(lon_all, lat_all, eof_all, Lon, Lat, 'natural');

% -------------------------
% PLOT
% -------------------------


figure1 = figure('Color',[1 1 1]);
colormap(jet);



axes1 = axes('Parent',figure1);
hold(axes1,'on');

zmin = min(Z);
zmax = max(Z);

z_norm = (Z - zmin) ./ (zmax - zmin);



figure (1)
contourf(Lon, Lat, Z, 100, 'LineColor','none');
colorbar;
colormap(jet);

hold on;

% Estações espelhadas 
scatter(lon, lat, 30, 'k', 'filled');



hold on;


% --- Adicionar contorno do Brasil ---
brasil = shaperead('BR_UF_2019.shp','UseGeoCoords',true); % shapefile na mesma pasta
for k = 1:length(brasil)
    plot(brasil(k).Lon, brasil(k).Lat, 'k', 'LineWidth', 1.5);
end

% Limites desejados
xlim([-67,-36])
ylim([-30, 3])

% Labels e título
xlabel('Longitude')
ylabel('Latitude')
title('Mapa do Brasil limitado')

hold off;
axis equal;  % Mantém proporção real das coordenadas


%Uncomment the following line to preserve the X-limits of the axes
 xlim(axes1,[-67 -36]);
% Uncomment the following line to preserve the Y-limits of the axes
 ylim(axes1,[-30 3]);

return


% Contorno do Brasil
try
    land = shaperead('landareas','UseGeoCoords',true);
    for k = 1:length(land)
        if strcmpi(land(k).Name,'Brazil')
            geoshow(land(k).Lat, land(k).Lon,'Color','k','LineWidth',1);
        end
    end
catch
    warning('Shapefile do Brasil não encontrado.');
end

% Estações originais
scatter(lon, lat, 30, 'k', 'filled');

% Estações espelhadas
scatter(lon_sym, lat_sym, 30, 'r', 'filled');

% Labels
for i = 1:length(lon)
    text(lon(i), lat(i), names{i}, 'FontSize',7,...
        'HorizontalAlignment','center');
end

title('EOF1 (Padrão espacial) – PCA TEC 2011 (simetrizado)');
xlabel('Longitude');
ylabel('Latitude');
axis tight;

