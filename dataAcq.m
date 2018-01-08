%%%%% Stored Data Acuisition
function [Weatherforecast,cond10]=dataAcq(timestep_sampling)
%%timestepmins
folder=uigetdir;
folder='C:\Users\ga49laj\Desktop\pvpredictiongit-master\Data';
files = dir(folder);
fileIndex = find(~[files.isdir]);
Data_Accum=struct();
%Data Failures Report%%%% 
DataFailures=struct();
fileIndexWfailure=fileIndex;
j=0;
fadd=0;
for i = 1:1:length(fileIndex)
    if  (i < length(fileIndex)-1) && (files(fileIndex(i+1)).datenum - files(fileIndex(i)).datenum > 1.5)
         diff=round((files(fileIndex(i+1)).datenum - files(fileIndex(i)).datenum));
        if diff > 1
            k=diff-1;
        else
            k=diff;
        end
         missedData=files(fileIndex(i)).datenum+day(1):day(1):files(fileIndex(i+1)).datenum;
        DataFailures.MissedFiles.datenum(j+1:j+k)=missedData(1:k);
        
        fileIndexWfailure=[fileIndexWfailure(1:i+j) zeros(k,1)' fileIndex(i+1:end)];
       j=j+k;

    end
end
%%%%CreateFailureIndex
m=length(fileIndexWfailure);
for i=1:m

end

%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%load Files and Matrices inialization

EmptyMatrix=zeros(m,240+(m*24));
EmptyCell=cell(m,240+(m*24));
EmptyCell(:,:)=cellstr('NA');
temp=EmptyMatrix;
uvi=EmptyMatrix;
cond=EmptyCell;
sky=EmptyMatrix;
wspd=EmptyMatrix;
wdir=EmptyMatrix;
snow=EmptyMatrix;
humidity=EmptyMatrix;
mslp=EmptyMatrix;
wx=EmptyCell;
k=0;
currentStep = zeros(1,2);
for i = 1:1:m
%Data Extraction and Concatination%%%
    if fileIndexWfailure(i)>0
        currentStep(1,1) = i;
        fileName = files(fileIndexWfailure(i)).name;
        load(strcat(folder,'\', fileName));
        for j=1:240
        %Temperature:
        currentStep(1,2) = j;
        save('currentSteps.mat','currentStep');
        %save('currentDataOut.mat','DataOut');
        %Pfad = DataOut.data.hourly_forecast{1,j};
        if isfield(DataOut.data,'hourly_forecast') ~= 0
            if isempty(DataOut.data.hourly_forecast) == 0 
            %if isfield(DataOut.data.hourly_forecast{1,j},'temp') ~= 0
                temp(i,k+j)=str2num(DataOut.data.hourly_forecast{1,j}.temp.metric);
                uvi(i,k+j)=str2num(DataOut.data.hourly_forecast{1,j}.uvi);
                cond(i,k+j)=cellstr(DataOut.data.hourly_forecast{1,j}.condition);
                sky(i,k+j)=str2num(DataOut.data.hourly_forecast{1,j}.sky);
                wspd(i,k+j)=str2num(DataOut.data.hourly_forecast{1,j}.wspd.metric);
                wdir(i,k+j)=str2num(DataOut.data.hourly_forecast{1,j}.wdir.degrees);
                snow(i,k+j)=str2num(DataOut.data.hourly_forecast{1,j}.snow.metric);
                humidity(i,k+j)=str2num(DataOut.data.hourly_forecast{1,j}.humidity);
                mslp(i,k+j)=str2num(DataOut.data.hourly_forecast{1,j}.mslp.metric);
                wx(i,k+j)=cellstr(DataOut.data.hourly_forecast{1,j}.wx);
            else
                temp(i,k+j)=str2num('NaN');
                uvi(i,k+j)=str2num('NaN');
                cond(i,k+j)=cellstr('Clear');
                sky(i,k+j)=str2num('NaN');
                wspd(i,k+j)=str2num('NaN');
                wdir(i,k+j)=str2num('NaN');
                snow(i,k+j)=str2num('NaN');
                humidity(i,k+j)=str2num('NaN');
                mslp(i,k+j)=str2num('NaN');
                wx(i,k+j)=cellstr('NaN');
            end
        else
            temp(i,k+j)=str2num('NaN');
            uvi(i,k+j)=str2num('NaN');
            cond(i,k+j)=cellstr('Clear');
            sky(i,k+j)=str2num('NaN');
            wspd(i,k+j)=str2num('NaN');
            wdir(i,k+j)=str2num('NaN');
            snow(i,k+j)=str2num('NaN');
            humidity(i,k+j)=str2num('NaN');
            mslp(i,k+j)=str2num('NaN');
            wx(i,k+j)=cellstr('NaN');
        end
        end
    end
k=(i*24);
end

%%% Data Post Processing 
%Post Processing Initialization
n=(m+9)*24;
EmptyMatPost=zeros(10,n); 
EmptycellPost=cell(10,n);%% +10 refers to the 10 days forecast

temp10=EmptyMatPost;
uvi10=EmptyMatPost;
cond10=EmptycellPost;
sky10=EmptyMatPost;
wspd10=EmptyMatPost;
wdir10=EmptyMatPost;
snow10=EmptyMatPost;
humidity10=EmptyMatPost;
mslp10=EmptyMatPost;
wx10=EmptycellPost;

temp10(1:10,1:240)=temp(1:10,1:240);
temp10(1:10,n-239:n)=temp(m-9:m,n-239:n);

uvi10(1:10,1:240)=uvi(1:10,1:240);
uvi10(1:10,n-239:n)=uvi(m-9:m,n-239:n);

cond10(1:10,1:240)=cond(1:10,1:240);
cond10(1:10,n-239:n)=cond(m-9:m,n-239:n);

sky10(1:10,1:240)=sky(1:10,1:240);
sky10(1:10,n-239:n)=sky(m-9:m,n-239:n);

wspd10(1:10,1:240)=wspd(1:10,1:240);
wspd10(1:10,n-239:n)=wspd(m-9:m,n-239:n);

wdir10(1:10,1:240)=wdir(1:10,1:240);
wdir10(1:10,n-239:n)=wdir(m-9:m,n-239:n);

snow10(1:10,1:240)=snow(1:10,1:240);
snow10(1:10,n-239:n)=snow(m-9:m,n-239:n);

humidity10(1:10,1:240)=humidity(1:10,1:240);
humidity10(1:10,n-239:n)=humidity(m-9:m,n-239:n);

mslp10(1:10,1:240)=mslp(1:10,1:240);
mslp10(1:10,n-239:n)=mslp(m-9:m,n-239:n);

wx10(1:10,1:240)=wx(1:10,1:240);
wx10(1:10,n-239:n)=wx(m-9:m,n-239:n);
     i=2;
    for j=241:24:n-240
   
        temp10(1:10,j:j+23)=temp(i:i+9,j:j+23);
        uvi10(1:10,j:j+23)=uvi(i:i+9,j:j+23);
        cond10(1:10,j:j+23)=cond(i:i+9,j:j+23);
        sky10(1:10,j:j+23)=sky(i:i+9,j:j+23);
       wspd10(1:10,j:j+23)=wspd(i:i+9,j:j+23);
        wdir10(1:10,j:j+23)=wdir(i:i+9,j:j+23);
        snow10(1:10,j:j+23)=snow(i:i+9,j:j+23);
        humidity10(1:10,j:j+23)=humidity(i:i+9,j:j+23);
          mslp10(1:10,j:j+23)=mslp(i:i+9,j:j+23);
           wx10(1:10,j:j+23)=wx(i:i+9,j:j+23);
      
        i=i+1;
     
    end

cond10mat=nan(10,length(cond10));
%%Processing Condstrings
NA=strcmp(cond10,'exact');
C=strcmp(cond10,'Clear');
F=strcmp(cond10,'Fog');
P=strcmp(cond10,'Partly Cloudy');
M=strcmp(cond10,'Mostly Cloudy');
O=strcmp(cond10,'Overcast');
CR=strcmp(cond10,'Chance of Rain');
CT=strcmp(cond10,'Chance of a Thunderstorm');
R=strcmp(cond10,'Rain');
T=strcmp(cond10,'Thunderstorm');
S=strcmp(cond10,'Snow');
SS=strcmp(cond10,'Snow Showers');


cond10mat(NA)=0;

cond10mat(C)=1;
cond10mat(F)=2;
cond10mat(P)=3;
cond10mat(M)=4;
cond10mat(O)=5;
cond10mat(CR)=6;
cond10mat(CT)=7;
cond10mat(R)=8;
cond10mat(T)=9;
cond10mat(S)=10;
cond10mat(SS)=11;

%%%%%WX%%%
wx10mat=nan(10,length(wx10));
unqwx=unique(wx);
for i=1:1:length(unqwx);
    wxsearch=strcmp(wx10,unqwx(i));
wx10mat(wxsearch)=i;
end

%%%%%%%%%%%%%%%%%  
temp10=timeseries(temp10','name','temp');
  uvi10=timeseries(uvi10','name','uvi');
   cond10=timeseries(cond10mat','name','cond');
    sky10=timeseries(sky10','name','sky');
     wspd10=timeseries(wspd10','name','wspd');
      wdir10=timeseries(wdir10','name','wdir');
       snow10=timeseries(snow10','name','snow');
        humidity10=timeseries(humidity10','name','humidity');
         mslp10=timeseries(mslp10','name','mslp');
          wx10=timeseries(wx10mat','name','wx');
  %Starttime=datevec(files(3).datenum); Starttime(6)=0;
  formatIn = 'yyyymmdd';
  Starttime=datevec(files(3).name(1:8),formatIn);
UTC=0;
  Starttime=datetime(Starttime);
  %Endtime=datetime(datevec(files(end).datenum));
  %Endtime=datetime(datevec(files(end).name(1:8),formatIn));
  Endtime=datetime(Starttime+days(409));
  timestep=60;
time=Starttime+minutes(60)-hours(UTC):minutes(timestep):Endtime+days(10)-hours(UTC);

time=datestr(time(1:end));
   Weatherforecast=tscollection({temp10,uvi10,sky10,wspd10,wdir10,snow10,cond10,humidity10,mslp10,wx10},'name','Weatherforecast');
   Weatherforecast=setabstime(Weatherforecast,time);
if timestep_sampling < timestep
  time=Starttime+minutes(60):minutes(timestep_sampling):Endtime+days(10);
  time=datestr(time(1:end));
  Weatherforecast=resample(Weatherforecast,time);
end


end