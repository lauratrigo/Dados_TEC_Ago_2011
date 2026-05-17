function frameRGB = eof_to_pixels(lat, lon, eof1, cmap, clim)

    % =========================
    % SIMETRIZAÇÃO (igual ao seu código)
    % =========================
    lat_all = [
        lat;
        lat;
        abs(lat);
        abs(lat);
        lat;
        abs(lat)+2*min(lat);
        abs(lat)+2*min(lat);
        abs(lat);
        abs(lat)+2*min(lat)
    ];

    lon_all = [
        lon;
        abs(lon)+2*max(lon);
        lon;
        abs(lon)+2*max(lon);
        abs(lon)+2*min(lon);
        lon;
        abs(lon)+2*max(lon);
        abs(lon)+2*min(lon);
        abs(lon)+2*min(lon)
    ];

    eof_all = repmat(eof1, 9, 1);

    % =========================
    % INTERPOLAÇÃO
    % =========================
    lon_vec = linspace(min(lon_all)-1, max(lon_all)+1, 300);
    lat_vec = linspace(min(lat_all)-1, max(lat_all)+1, 300);
    [Lon, Lat] = meshgrid(lon_vec, lat_vec);

    Z = griddata(lon_all, lat_all, eof_all, Lon, Lat, 'natural');

    % =========================
    % NORMALIZAÇÃO ? CORES
    % =========================
    Z(Z < clim(1)) = clim(1);
    Z(Z > clim(2)) = clim(2);

    Znorm = (Z - clim(1)) / diff(clim);
    Znorm(isnan(Znorm)) = 0;

    idx = round(Znorm * (size(cmap,1)-1)) + 1;
    idx(idx < 1) = 1;
    idx(idx > size(cmap,1)) = size(cmap,1);

    % =========================
    % RGB FINAL
    % =========================
    frameRGB = ind2rgb(idx, cmap);
    frameRGB = uint8(255 * frameRGB);
end
