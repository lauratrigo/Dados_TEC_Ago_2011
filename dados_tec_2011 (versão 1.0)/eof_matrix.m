function eof_matrix(lat, lon, eof1)



    % =========================
    % PLOT (antigo plot_eof_map)
    % =========================
    %figure('Color',[1 1 1]);
    colormap(jet);
    hold on;

    contourf(Lon, Lat, Z, 20, 'LineColor','none');
    colorbar;
    
     % ---- ESCALA PADRONIZADA ----
    %cmax = max(abs(eof_all));
    caxis([-3 3]);
%     colorbar;
% 
     scatter(lon_all, lat_all, 30, 'k', 'filled');

    brasil = shaperead('BR_UF_2019.shp','UseGeoCoords',true);
    for k = 1:length(brasil)
        plot(brasil(k).Lon, brasil(k).Lat, 'k', 'LineWidth', 1.5);
    end

    axis equal;
    xlim([min(lon) max(lon)]);
    ylim([min(lat) max(lat)]);

    xlabel('Longitude');
    ylabel('Latitude');
    title('EOF simetrizado');

    hold off;

end