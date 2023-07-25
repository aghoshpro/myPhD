import('se.hendeby.sensordata.*');

dataFilename = FileSensorDataReader('sensorLog_20221028T145848.txt');
dataFilename.start();

% Normal measurement data
dataFilename.reset();
data = dataFilename.getAll(5); % Group things separated less than half a period

% Process data one row per time stamp

time = data(:,1);

% Acceleration Vector
AccX = data(:,2);
AccY = data(:,3);
AccZ = data(:,4);

norm_Acc = sqrt(AccX.^2 + AccY.^2+AccZ.^2); % We worked with this 

% Gyrovector Vector

GyrX = data(:,5);
GyrY = data(:,6);
GyrZ = data(:,7);

norm_Gyr = sqrt(GyrX.^2 + GyrY.^2+GyrZ.^2);

% Magnetometer Vector

MagX = data(:,8);
MagY = data(:,9);
MagZ = data(:,10);

norm_Mag = sqrt(MagX.^2 + MagY.^2+MagZ.^2);

%%% ****************** DETECTION PART ******************** %%%
Activities = ["I am Standing";"I am Walking";"I am Running"];

        if  var(norm_Acc, 'omitnan')<=1 %varience
            Count = [1;0;0];
        elseif var(norm_Acc, 'omitnan')<=10
            Count = [0;1;0];
        else
            Count = [0;0;1];
        end

ActivityTable = table(Activities,Count);

fig01 = figure('units','normalized','outerposition',[0 0 1 1]);
wordcloud(ActivityTable,'Activities','Count');
title("Detection Wordcloud")


