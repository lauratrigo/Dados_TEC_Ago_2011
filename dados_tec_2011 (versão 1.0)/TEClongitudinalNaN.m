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

%matrix_list = readmatrix('matrix_diffTEC_Aug2011_dias_evento.txt');

nan_mask = isnan(matrix_list);   % salva onde tem NaN

% % cópia só para PCA
% matrix_temp = fillmissing(matrix_list,'linear');
% matrix_temp = fillmissing(matrix_temp,'nearest');
% 
% [coeff,score,latent] = pca(matrix_temp);

matrix_list(isnan(matrix_list)) = 0;

[coeff,score,latent,tsquared,explained] = pca(matrix_list);

pca1 = score(:,4:end) * coeff(:,4:end)';

% recoloca os NaNs originais
pca1(nan_mask) = NaN;



stations = {'RIOB', 'POVE', 'ROCD', 'ROJI', 'CUIB', 'GOJA', 'PPTE', 'SPAR', 'SJRP'};

[lia, idx_num] = ismember(stations, names);

% segurança
idx_num = idx_num(lia);
stations_plot = stations(lia);


names(idx_num)


for i = 1:length(idx_num)


    ind = idx_num(i);   % índice real da estação no vetor original
    
    % -------------------------
    % Extrair dados da estação
    % -------------------------
    vtec_data = pca1(:, ind);
    
        
    % -------------------------
    % Eixo do tempo
    % -------------------------
    time = linspace(datenum(2011,8,1), ...
                    datenum(2011,9,1), ...
                    length(vtec_data));

% Initialize figure
figure(1)
hold on;

% Number of days and hours per day
num_days = 31; % From 12 to 23 of October
hours_per_day = 24; % Hours per day

% Define major ticks
major_ticks = datenum(2011, 8, 1):datenum(2011, 9, 1); % Major ticks from October 12th to 23rd


% Calculate minor ticks: three minor ticks between each major tick
minor_ticks = [];
for k = 1:length(major_ticks)-1
    minor_ticks = [minor_ticks, linspace(major_ticks(k), major_ticks(k+1), 5)]; % Divide each day into 4 (3 intervals)
end
minor_ticks = setdiff(minor_ticks, major_ticks); % Remove the major ticks to keep only minor


             
             
    % Define the time axis
    time = linspace(datenum(2011,8,1), datenum(2011,9,1), length(vtec_data));
    
    if i~=length(idx_num)
    figure(1)
    % Create subplot for the current station
    subplot(length(idx_num), 1, i);
    % Plot PC% VTEC
    
    
    plot(time, vtec_data, 'b.-');
    
    %plot(time, vtec_data, 'b-','LineWidth',1);

    
    xlim([time(1) time(end)])   % ? remove bordas brancas

    ylim([-15 15])
    
    % Set minor ticks on the x-axis
    ax = gca;
    ax.YColor = 'k';
    hold on;
   
    ylabel(sprintf('%s\n\\Delta VTEC', stations_plot{i}));
    
   %ylim([-20,20])
    % Set x-axis ticks and labels
    xticks(major_ticks);
    xticklabels([]);
    ax = gca;
    ax.XAxis.MinorTick = 'on';
    ax.XAxis.MinorTickValues = minor_ticks;
    
    
    else
       disp('passei')
         
      figure (1)
    % Create subplot for the current station
    subplot(length(idx_num), 1, i);
    % Plot differences for h'F
    
     
     plot(time, vtec_data, 'b.-');
     
     xlim([time(1) time(end)])   % ? remove bordas brancas
    
    % Set minor ticks on the x-axis
    ax = gca;
    ax.YColor = 'k';
    hold on;
    % Set plot titles and labels
    %title([stations{i}]);
    %ylabel('\Delta VTEC');
    ylabel(sprintf('%s\n\\Delta VTEC', stations{i}));
    
    ylim([-15,15])
    % Set x-axis ticks and labels
    xticks(major_ticks);
    xticklabels(datestr(major_ticks, 'dd-mmm'));
    ax = gca;
    ax.XAxis.MinorTick = 'on';
    ax.XAxis.MinorTickValues = minor_ticks;
    
    
    
    end




%writematrix(matrix_diffTEC,'matrix_diffTECAug2011.txt','Delimiter', ' ')
 
figure1=figure(1)

% Create rectangle
annotation(figure1,'rectangle',...
    [0.879645833333333 0.110236220472441 0.0255625000000002 0.813273340832405],...
    'Color',[0 0 1],...
    'FaceColor',[0.729411780834198 0.831372559070587 0.95686274766922],...
    'FaceAlpha',0.2);

% Create line
annotation(figure1,'line',[0.722395833333333 0.722916666666666],...
    [0.105861642294715 0.922384701912263],'LineWidth',2,'LineStyle','--');

% Create rectangle
annotation(figure1,'rectangle',...
    [0.8546875 0.110236220472445 0.024999999999998 0.813273340832406],...
    'Color',[0 0 1],...
    'FaceColor',[0.729411780834198 0.831372559070587 0.95686274766922],...
    'FaceAlpha',0.2);

% Create rectangle
annotation(figure1,'rectangle',...
    [0.155687499999998 0.110236220472445 0.0245208333333354 0.813273340832406],...
    'Color',[0 0 1],...
    'FaceColor',[0.729411780834198 0.831372559070587 0.95686274766922],...
    'FaceAlpha',0.2);

% Create rectangle
annotation(figure1,'rectangle',...
    [0.180166666666665 0.111361079865019 0.0255624999999998 0.813273340832406],...
    'Color',[0 0 1],...
    'FaceColor',[0.729411780834198 0.831372559070587 0.95686274766922],...
    'FaceAlpha',0.2);

% Create rectangle
annotation(figure1,'rectangle',...
    [0.230166666666665 0.111361079865022 0.0255624999999997 0.813273340832406],...
    'Color',[1 0 0],...
    'FaceColor',[0.7 0.3 0.3],...
    'FaceAlpha',0.1);

% Create rectangle
annotation(figure1,'rectangle',...
    [0.255687499999998 0.110236220472445 0.0250416666666691 0.813273340832406],...
    'Color',[1 0 0],...
    'FaceColor',[0.7 0.3 0.3],...
    'FaceAlpha',0.1);

% Create rectangle
annotation(figure1,'rectangle',...
    [0.455687499999997 0.111361079865023 0.0245208333333364 0.813273340832406],...
    'Color',[1 0 0],...
    'FaceColor',[0.7 0.3 0.3],...
    'FaceAlpha',0.1);

% Create rectangle
annotation(figure1,'rectangle',...
    [0.480166666666665 0.111361079865022 0.0255625000000022 0.813273340832406],...
    'Color',[1 0 0],...
    'FaceColor',[0.7 0.3 0.3],...
    'FaceAlpha',0.1);

% Create rectangle
annotation(figure1,'rectangle',...
    [0.680166666666664 0.110236220472447 0.025041666666669 0.813273340832406],...
    'Color',[1 0 0],...
    'FaceColor',[0.7 0.3 0.3],...
    'FaceAlpha',0.1);

% Create rectangle
annotation(figure1,'rectangle',...
    [0.430166666666665 0.110236220472444 0.0255624999999998 0.813273340832406],...
    'Color',[0 0 1],...
    'FaceColor',[0.729411780834198 0.831372559070587 0.95686274766922],...
    'FaceAlpha',0.2);

% Create rectangle
annotation(figure1,'rectangle',...
    [0.554645833333332 0.11136107986502 0.0250416666666685 0.813273340832406],...
    'Color',[0 0 1],...
    'FaceColor',[0.729411780834198 0.831372559070587 0.95686274766922],...
    'FaceAlpha',0.2);

% Create rectangle
annotation(figure1,'rectangle',...
    [0.579645833333331 0.111361079865021 0.0250416666666685 0.813273340832406],...
    'Color',[0 0 1],...
    'FaceColor',[0.729411780834198 0.831372559070587 0.95686274766922],...
    'FaceAlpha',0.2);

% Create rectangle
annotation(figure1,'rectangle',...
    [0.629645833333331 0.111361079865021 0.0250416666666685 0.813273340832406],...
    'Color',[0 0 1],...
    'FaceColor',[0.729411780834198 0.831372559070587 0.95686274766922],...
    'FaceAlpha',0.2);

% Create rectangle
annotation(figure1,'rectangle',...
    [0.405166666666664 0.111361079865021 0.0250416666666687 0.813273340832406],...
    'Color',[0 0 1],...
    'FaceColor',[0.729411780834198 0.831372559070587 0.95686274766922],...
    'FaceAlpha',0.2);

% Create rectangle
annotation(figure1,'rectangle',...
    [0.380166666666665 0.111361079865021 0.0250416666666685 0.813273340832406],...
    'Color',[0 0 1],...
    'FaceColor',[0.729411780834198 0.831372559070587 0.95686274766922],...
    'FaceAlpha',0.2);

end