function Z = interpolate_eof(eof, lon_all, lat_all, Lon, Lat)

eof_all = repmat(eof, 9, 1);
Z = griddata(lon_all, lat_all, eof_all, Lon, Lat, 'natural');

end
