%importing of Data

    file_Name_of_spinodoid_data_sheet = append('Compression_Spinodoid','1','.csv');
    file_Name_of_multimeter_data_sheet = append('multimeterReading','1','.csv');
    MachineData = readtable(file_Name_of_spinodoid_data_sheet,'Delimiter',',','ReadVariableNames',false);
    MultimeterData = readtable(file_Name_of_multimeter_data_sheet,'ReadVariableNames',false);
    spinodoid_Data_Sheet = readtable("Spinodoid_data_sheet.csv",'ReadVariableNames',false);
%% Deriving required values from the Data
    surface_area=spinodoid_Data_Sheet{1,13};
    original_length = spinodoid_Data_Sheet{1,14};
    Force= MachineData{:,1};  
    Displacement= MachineData{:,2};
    Stress = Force./surface_area;
    Stress=Stress(~isnan(Stress));
    Strain=  Displacement./original_length;
    Strain=Strain(~isnan(Strain));
    Time_of_MachineData = MachineData{:,3};
    Time_of_MachineData= Time_of_MachineData(~isnan(Time_of_MachineData));
    Resistance = MultimeterData{:,1};
    Resistance_without_nan = Resistance(~isnan(Resistance));
    EndDate=char(MultimeterData{end,3});
    StartDate=char(MultimeterData{1,3});
%% Generating new sets to plot the graphs

Time_obtained_in_Multimeter = round((datenum(EndDate,'HH:MM:SS') - datenum(StartDate,'HH:MM:SS'))*(24*3600));
size_of_multimeter_data=length(Resistance)
time_Range = Time_obtained_in_Multimeter/size_of_multimeter_data;
X=[];
New_time_set = 0;
%%%%%%%%%%........................%%%%%%%%%%%......................%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%creating a data set for time for the size of resistance
for i=1:size(Resistance)
    New_time_set = New_time_set+time_Range;
    X=[X,New_time_set];
end
Time_data_set_of_multimeter = X.';
%%%%%%%%%%........................%%%%%%%%%%%......................%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
mean_of_resistance=mean(Resistance_without_nan);
%%%%%%%%%%........................%%%%%%%%%%%......................%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
New_Resistance =[];
Unnecessary_Resistance =[];
New_Time_data_setof_multimeter = [];

%creating a new data set for time and resistance of multimeter
for i=1:size(Resistance_without_nan)
    if( Resistance_without_nan(i)>1000)
        New_Resistance =[New_Resistance,Resistance_without_nan(i)];
        New_Time_data_setof_multimeter = [New_Time_data_setof_multimeter,Time_data_set_of_multimeter(i)];
    else
        Unnecessary_Resistance = [Unnecessary_Resistance,Resistance(i)];
    end        
end
New_Resistance = New_Resistance';
New_Time_data_setof_multimeter= New_Time_data_setof_multimeter';
%% Plotting the graphs with new data set

%%%%%%%%%%........................%%%%%%%%%%%......................%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%plotting a graph between newly obtained time and resistance of multimeter data

figure(1);  
plot(New_Time_data_setof_multimeter,New_Resistance,'b');
xlabel('Time_data_set_of_multimeter');
ylabel('New_Resistance');
grid;

figure(2);
plot(Time_of_MachineData,Stress);
xlabel('Time_of_MachineData');
ylabel('Stress');
grid;
%% Interpolation of data sets
% Curve 2 has more points than curve 1 so let's interpolate curve 1
% to have as many points as curve 2
x = 1 : length(Time_of_MachineData);
x1Interp = interp1(New_Time_data_setof_multimeter, New_Resistance,Time_of_MachineData);
%% Now plotting two graphs and interpolation graph
%pltting two pair of points above and below
figure(3)
tiledlayout(3,1)
% Top plot
nexttile
plot(New_Time_data_setof_multimeter,New_Resistance,'b');
xlabel('Time');
ylabel('Resistance');
title('Time vs Resistance')

% middle plot
nexttile
plot(Time_of_MachineData,x1Interp,'r');
xlabel('Time');
ylabel('Resistance');
title('Time vs Resistance-after Interpolation')

% Bottom plot
nexttile
plot(Time_of_MachineData,Stress);
xlabel('Time');
ylabel('Stress');
title('time vs stress')
%saveas(gcf,'relative_density_of_0.38.png');
%% Plotting graps of stress vs strain and resistance and strain

figure(4)
tiledlayout(2,1)
% Top plot
nexttile
plot(Strain,Stress,'b');
xlabel('Strain');
ylabel('Stress');
title('Stress vs Strain')

% Bottom plot
nexttile
plot(Strain,x1Interp,'r');
xlabel('Strain');
ylabel('New_Resistance');
title('Resistance vs strain')
%saveas(gcf,'relative_density_of_0.38.png');

