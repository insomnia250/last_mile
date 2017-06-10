function totaldistance = CalculateTotalDistance (solution , distanceMatrix)
numberofjourney = numel (solution) - 1;
totaldistance = 0 ;
for i = 1 : numberofjourney
    totaldistance = totaldistance + distanceMatrix (solution (i), solution (i+1));
end
