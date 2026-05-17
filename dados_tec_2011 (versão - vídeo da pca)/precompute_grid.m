function [Lon, Lat, lon_all, lat_all] = precompute_grid(lat, lon)

lat_all = [ ...
    lat;
    lat;
    abs(lat);
    abs(lat);
    lat;
    abs(lat)+2*min(lat);
    abs(lat)+2*min(lat);
    abs(lat);
    abs(lat)+2*min(lat)];

lon_all = [ ...
    lon;
    abs(lon)+2*max(lon);
    lon;
    abs(lon)+2*max(lon);
    abs(lon)+2*min(lon);
    lon;
    abs(lon)+2*max(lon);
    abs(lon)+2*min(lon);
    abs(lon)+2*min(lon)];

lon_vec = linspace(min(lon_all)-1, max(lon_all)+1, 400);
lat_vec = linspace(min(lat_all)-1, max(lat_all)+1, 400);
[Lon, Lat] = meshgrid(lon_vec, lat_vec);

end
