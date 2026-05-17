% Generate sample data
Z = peaks(50);

% Define contour levels (e.g., 10 levels)
levels = 10;

% Get contour matrix C, NO PLOT PRODUCED
C = contourc(Z, levels);

% Save C to a .mat file
save('contourData.mat', 'C');
