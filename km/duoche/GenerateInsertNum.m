function randNum=GenerateInsertNum(CityNum,VehicleNum)
randNum=zeros(1,VehicleNum-1);      %����㣬��������೵����
    tempNum=0;
    for i=1:VehicleNum-1
        taskLength=randi(CityNum-tempNum-VehicleNum+i);
        randNum(i)=tempNum+taskLength;
        tempNum=randNum(i);    
    end
end