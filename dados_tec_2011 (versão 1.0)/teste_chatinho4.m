clear; clc;

opengl software
set(0,'DefaultFigureRenderer','painters')

% Grade original
x = linspace(-2*pi, 2*pi, 100);
y = linspace(0, 4*pi, 100);
[Xg,Yg] = meshgrid(x,y);

% Campo original
Zg = sin(Xg) + cos(Yg);

% Define contour levels (e.g., 10 levels)
levels = 10;

% Get contour matrix C, NO PLOT PRODUCED
C = contourc(Zg, levels);

return

% Gera contour matrix (não visível)
C = contour(Xg, Yg, Zg);

% Extrai curvas
[Xc, Yc, Zc] = C2xyz_matrix(C);

return

% Reconstrói campo Z(i,j)
[Xr, Yr, Zr] = contour2grid(Xc, Yc, Zc, 200, 200, 'natural');


% =========================
% FIGURA 1 – campo original
% =========================
figure(1)
contourf(Xg, Yg, Zg, 20, 'LineStyle','none')

[x,y,z]=contourf(Xg, Yg, Zg, 20, 'LineStyle','none');
axis equal
title('Campo original')
%colorbar

% =========================
% FIGURA 2 – campo reconstruído
% =========================
figure(5)
contourf(Xr, Yr, Zr, 20, 'LineStyle','none')
axis equal
title('Campo reconstruído a partir do contour')
%colorbar

% =========================
% FIGURA 3 – curvas do contour
% =========================
figure(3)
hold on
for k = 1:length(Zc)
    plot3d(x(:,k), y(:,k),z(:,k), 'k')
end
axis equal
title('Curvas do contour (Xc,Yc)')
hold off

% =========================================================
% ===================== VÍDEO ==============================
% =========================================================

% Parâmetros do vídeo
video = VideoWriter('campo_reconstruido.mp4','MPEG-4');
video.FrameRate = 10;
open(video);

% Colormap e escala FIXA (importantíssimo)
cmap = parula(256);
zmin = min(Zr(:));
zmax = max(Zr(:));

% Aqui eu só uso UM frame (exemplo),
% mas este bloco vai normalmente dentro de um loop no tempo
Z = Zr;

% Normaliza
Znorm = (Z - zmin) / (zmax - zmin);
Znorm = max(0, min(1, Znorm));

% Converte para índice de cor
idx = round(Znorm * (size(cmap,1)-1)) + 1;

% Cria imagem RGB
RGB = ind2rgb(idx, cmap);

% Converte para uint8
frame = im2uint8(RGB);

% Grava frame
writeVideo(video, frame);

% Fecha vídeo
close(video);

disp('Vídeo salvo com sucesso!');

