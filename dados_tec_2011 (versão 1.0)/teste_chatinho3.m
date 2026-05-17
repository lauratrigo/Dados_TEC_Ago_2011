clear; clc;

opengl software
set(0,'DefaultFigureRenderer','painters')

% Grade de teste
x = linspace(-2*pi, 2*pi);
y = linspace(0, 4*pi);
[Xg,Yg] = meshgrid(x,y);

% Campo
Zg = sin(Xg) + cos(Yg);

% Gera a matriz de contorno (NÃO precisa plotar visivelmente)
C = contour(Xg, Yg, Zg);

% Converte contorno para MATRIZES
[Xc, Yc, Zc] = C2xyz_matrix(C);

% Reconstrói Z(i,j) em um grid
[Xr, Yr, Zr] = contour2grid(Xc, Yc, Zc, 200, 200, 'natural');

% figure
% hold on
% 
% cmap = parula(256);          % mesmo colormap do contour (default)
% caxis([min(Zc) max(Zc)])     % escala de cores
% 
% for k = 1:length(Zc)
%     % normaliza Z para índice de cor
%     idx = round( ...
%         (Zc(k) - min(Zc)) / (max(Zc) - min(Zc)) * (size(cmap,1)-1) ...
%         ) + 1;
% 
%     idx = max(1, min(idx, size(cmap,1)));
% 
%     plot(Xc(:,k), Yc(:,k), ...
%          'Color', cmap(idx,:), ...
%          'LineWidth', 1.2);
% end
% 
% axis equal
% axis tight
% hold off

% Exemplo: ver tamanhos
size(Xc)
size(Yc)
size(Zc)

% Exemplo: plotar só um nível (opcional)
 figure (3)

  contour(Xc, Yc, Zc)
  
hold on
 for k = 1:length(Zc)
      contour(Xc(:,k), Yc(:,k), Zc(:,k))
 end

figure(1)
hold on
for k = 1:length(Zc)
    plot(Xc(:,k), Yc(:,k))
end
axis equal
hold off
% axis equal
