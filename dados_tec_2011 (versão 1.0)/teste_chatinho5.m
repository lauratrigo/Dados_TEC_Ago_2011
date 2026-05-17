clear; clc;

opengl software
set(0,'DefaultFigureRenderer','painters')

% Grade original
x = linspace(-2*pi, 2*pi, 100);
y = linspace(0, 4*pi, 100);
[Xg,Yg] = meshgrid(x,y);

% Campo original
Zg = sin(Xg) + cos(Yg);


[x,y,z]=contourf(Xg, Yg, Zg, 20, 'LineStyle','none');

return

figure(3)
hold on
for k = 1:length(Zc)
    plot3d(x(:,k), y(:,k),z(:,k), 'k')
end
axis equal
title('Curvas do contour (Xc,Yc)')
hold off
return
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

