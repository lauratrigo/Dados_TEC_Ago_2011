function [X,Y,Z] = C2xyz_matrix(C)

Nc = size(C,2);

m = [];
k = 1;
idx = 1;

while idx <= Nc
    m(k) = idx;

    np = C(2,idx);          % número de pontos do contorno
    idx = idx + np + 1;     % pula para o próximo cabeçalho
    k = k + 1;
end

ncont = length(m);

% número de pontos por contorno
np = zeros(ncont,1);
for k = 1:ncont
    np(k) = C(2,m(k));
end

maxp = max(np);

% saída
X = NaN(maxp, ncont);
Y = NaN(maxp, ncont);
Z = NaN(1, ncont);

for k = 1:ncont
    pts = m(k)+1 : m(k)+np(k);
    X(1:np(k),k) = C(1,pts);
    Y(1:np(k),k) = C(2,pts);
    Z(k)         = C(1,m(k));   % nível do contorno
end

end
