function [Xg, Yg, Zg] = contour2grid(Xc, Yc, Zc, nx, ny, method)
% CONTOUR2GRID reconstrói um campo Z(i,j) a partir de curvas de contorno
%
% INPUT:
%   Xc, Yc : matrizes (np x ncont) com NaN
%   Zc     : vetor (1 x ncont) com os níveis
%   nx, ny : tamanho do grid (ex: 200, 200)
%   method : método de interpolação ('linear','natural','cubic')
%
% OUTPUT:
%   Xg, Yg : meshgrid
%   Zg     : matriz Z(i,j)

if nargin < 4 || isempty(nx); nx = 200; end
if nargin < 5 || isempty(ny); ny = nx; end
if nargin < 6 || isempty(method); method = 'natural'; end

% -------------------------
% Empilha todos os pontos
% -------------------------
Xall = [];
Yall = [];
Zall = [];

ncont = length(Zc);

for k = 1:ncont
    mask = ~isnan(Xc(:,k)) & ~isnan(Yc(:,k));
    Xk = Xc(mask,k);
    Yk = Yc(mask,k);
    Zk = Zc(k) * ones(size(Xk));

    Xall = [Xall; Xk];
    Yall = [Yall; Yk];
    Zall = [Zall; Zk];
end

% -------------------------
% Grid regular
% -------------------------
xg = linspace(min(Xall), max(Xall), nx);
yg = linspace(min(Yall), max(Yall), ny);
[Xg,Yg] = meshgrid(xg,yg);

% -------------------------
% Interpolação
% -------------------------
Zg = griddata(Xall, Yall, Zall, Xg, Yg, method);

end
