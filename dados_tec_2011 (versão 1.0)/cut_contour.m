function Ccut = cut_contour(C, lon_min, lon_max, lat_min, lat_max)

    Ccut = [];
    i = 1;

    while i < size(C,2)

        level = C(1,i);
        npts  = C(2,i);

        pts = C(:, i+1:i+npts);

        x = pts(1,:);
        y = pts(2,:);

        mask = x >= lon_min & x <= lon_max & ...
               y >= lat_min & y <= lat_max;

        x = x(mask);
        y = y(mask);

        if numel(x) > 1
            Ccut = [Ccut [level; numel(x)] [x; y]];
        end

        i = i + npts + 1;
    end
end
