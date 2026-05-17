clear all 
close all
clc

% [latitude longitude]
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
% 1) Carregar matriz dos arquivos TXT
% -------------------------
folder_path = 'C:\Users\vikla\Downloads\dados_tec_2011\formatado';
files = dir(fullfile(folder_path,'*.txt'));

matrix_list = [];
for i = 1:length(files)
    data = load(fullfile(folder_path, files(i).name));
    matrix_list = [matrix_list data]; %#ok<AGROW>
end

matrix_diffTEC = matrix_list;
fprintf('Shape da matriz carregada: %d x %d\n', size(matrix_diffTEC));



% -------------------------
% 2) Anomalia + NaNs
% -------------------------
X_anom = matrix_diffTEC - nanmean(matrix_diffTEC,1);
X_anom(isnan(X_anom)) = 0;

% -------------------------
% 3) Padronização global
% -------------------------
a = (X_anom - mean(X_anom(:))) / std(X_anom(:));
fprintf('Mean = %.2e | Std = %.2f\n', mean(a(:)), std(a(:)));

[Nt, N] = size(a);

% -------------------------
% 4) Covariância (estações = variáveis)
% -------------------------
C = cov(a);

% -------------------------
% 5) Eigenanalysis
% -------------------------
[E, LAM] = eig(C);

% ordenar por autovalor decrescente
[lambda_sorted, idx] = sort(diag(LAM),'descend');
E = E(:,idx);

% EOFs
eof1 = E(:,1);
eof2 = E(:,2);
eof3 = E(:,3);
eof4 = E(:,4);
eof5 = E(:,5);

% PCs
pc1 = zscore(a * eof1);
pc2 = zscore(a * eof2);
pc3 = zscore(a * eof3);
pc4 = zscore(a * eof4);
pc5 = zscore(a * eof5);

% -------------------------
% 6) Plots PCs
% -------------------------
figure;
subplot(5,1,1); plot(pc1,'r'); title('PC 1'); xlim([1 Nt])
subplot(5,1,2); plot(pc2,'b'); title('PC 2'); xlim([1 Nt])
subplot(5,1,3); plot(pc3,'g'); title('PC 3'); xlim([1 Nt])
subplot(5,1,4); plot(pc4,'c'); title('PC 4'); xlim([1 Nt])
subplot(5,1,5); plot(pc5,'m'); title('PC 5'); xlim([1 Nt])

