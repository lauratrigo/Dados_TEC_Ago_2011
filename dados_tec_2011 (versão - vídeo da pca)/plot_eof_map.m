function plot_eof_map(lat, lon, eof1)


    % =========================
    % SIMETRIZAÇÃO
    % =========================

    % CENTER
    lat_sym1 = lat;
    lon_sym1 = lon;
    eof_sym1 = eof1;

    % RIGHT
    lat_sym2 = lat;
    lon_sym2 = abs(lon) + 2*max(lon);
    eof_sym2 = eof1;

    % TOP CENTER
    lat_sym3 = abs(lat);
    lon_sym3 = lon;
    eof_sym3 = eof1;

    % TOP RIGHT
    lat_sym4 = abs(lat);
    lon_sym4 = abs(lon) + 2*max(lon);
    eof_sym4 = eof1;

    % BOTTOM CENTER
    lat_sym5 = lat;
    lon_sym5 = abs(lon) + 2*min(lon);
    eof_sym5 = eof1;

    % LEFT
    lat_sym6 = abs(lat) + 2*min(lat);
    lon_sym6 = lon;
    eof_sym6 = eof1;

    % BOTTOM RIGHT
    lat_sym7 = abs(lat) + 2*min(lat);
    lon_sym7 = abs(lon) + 2*max(lon);
    eof_sym7 = eof1;

    % TOP LEFT
    lat_sym8 = abs(lat);
    lon_sym8 = abs(lon) + 2*min(lon);
    eof_sym8 = eof1;

    % BOTTOM LEFT
    lat_sym9 = abs(lat) + 2*min(lat);
    lon_sym9 = abs(lon) + 2*min(lon);
    eof_sym9 = eof1;

    % =========================
    % CONCATENA TUDO
    % =========================
    lat_all = [lat_sym1; lat_sym2; lat_sym3; lat_sym4; lat_sym5; ...
               lat_sym6; lat_sym7; lat_sym8; lat_sym9];

    lon_all = [lon_sym1; lon_sym2; lon_sym3; lon_sym4; lon_sym5; ...
               lon_sym6; lon_sym7; lon_sym8; lon_sym9];

    eof_all = [eof_sym1; eof_sym2; eof_sym3; eof_sym4; eof_sym5; ...
               eof_sym6; eof_sym7; eof_sym8; eof_sym9];

    % =========================
    % INTERPOLAÇÃO
    % =========================
    lon_vec = linspace(min(lon_all)-1, max(lon_all)+1, 400);
    lat_vec = linspace(min(lat_all)-1, max(lat_all)+1, 400);
    [Lon, Lat] = meshgrid(lon_vec, lat_vec);

    Z = griddata(lon_all, lat_all, eof_all, Lon, Lat, 'natural');

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