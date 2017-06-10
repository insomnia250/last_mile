function distancematrix =  GenerateEarthDistanceMatrix2(Lng_coordinate, Lat_coordinate)
numberofcities = numel(Lng_coordinate);
distancematrix = zeros(numberofcities);
for i = 1 : numberofcities
    for j = 1 : i
        lng1=Lng_coordinate(i);
        lng2=Lng_coordinate(j);
        lat1=Lat_coordinate(i);
        lat2=Lat_coordinate(j);
        dlat=(lat1-lat2)/2;
        dlng=(lng1-lng2)/2;
        temp1=sqrt( ...
                            ( sin (pi/180*dlat) )^2 ...
                             + cos (pi/180*lat1) * cos (pi/180*lat2) ...
                              * ( sin (pi/180*dlng) ) ^2);
        distancematrix(i,j)= 2 * 6378137 * asin(temp1);
    end
end
