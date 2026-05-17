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
         'IMPZ','MABA','MGBH','MGIN','MGMC','MGRP','MGUB', 'MSCG'...
         'MTCN','MTCO','MTSF','MTSR','NAUS','NEIA','ONRJ','PAIT',...
         'PBCG','PEPE','PISR','PITN','POAL','POLI','POVE','PPTE',...
         'PRGU','PRMA','RIOB','RIOD','RJCG','RNMO','RNNA','ROCD',...
         'ROGM','ROJI','ROSA','SAGA','SALU','SAVO','SCCH','SCLA',...
         'SJRP','SMAR','SPAR','SSA1','TOGU','TOPL','UFPR','VICO'};

% -------------------------
% CARREGAR DADOS E PCA
% -------------------------
load('X_anom.mat')

nan_mask = isnan(matrix_list);   % salva onde tem NaN

% matrix_temp = fillmissing(matrix_list,'linear');
% matrix_temp = fillmissing(matrix_temp,'nearest');
% 
% [coeff,score,latent] = pca(matrix_temp);

matrix_list(isnan(matrix_list)) = 0;

[coeff,score,latent,tsquared,explained] = pca(matrix_list);

pca1 = score(:,4:end) * coeff(:,4:end)';

pca1(nan_mask) = NaN;


stations = {'RIOB', 'POVE', 'ROCD', 'ROJI', 'CUIB', 'GOJA', 'PPTE', 'SPAR', 'SJRP'};

[lia, idx_num] = ismember(stations, names);

idx_num = idx_num(lia);
stations_plot = stations(lia);


names(idx_num)

dt = 1/1440; 

time_full = datenum(2011,8,1,0,0,0) : dt : datenum(2011,8,1,0,0,0) + dt*(size(pca1,1)-1);

t_ini = datenum(2011,8,23,0,0,0);
t_fim = datenum(2011,8,26,23,59,59);
t_fim_axis = ceil(t_fim);   

mask = (time_full >= t_ini) & (time_full <= t_fim);

time = time_full(mask); 
major_ticks = floor(t_ini):1:t_fim_axis;

figure(1)
clf

for i = 1:length(idx_num)

    subplot(length(idx_num),1,i)
    
    vtec_data = pca1(mask, idx_num(i)); 
    
    plot(time, vtec_data, 'b.-','LineWidth',1)
    
    xlim([t_ini t_fim_axis])
    ylim([-15 15])
    box on
    
    ylabel({stations_plot{i},'\Delta VTEC'})
    
    ax = gca;
    ax.XMinorTick = 'on';
    ax.YColor = 'k';
    
    xticks(major_ticks)
    
    if i ~= length(idx_num)
        xticklabels([])
    else
        xticklabels(datestr(major_ticks,'dd-mmm'))
    end

end