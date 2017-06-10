function solusirandom = GenerateSolusiRandom (CityNum)
solusirandom = [] ;
temp = 3;
for i = 1: length(CityNum)
    solusirandom = [solusirandom randperm(CityNum(i))+temp];
    temp = temp + CityNum(i);
end

