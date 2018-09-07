function [TSTd,TSTm,TSTy,TSThh,TSTmm,TSTss,TETd,TETm,TETy,TEThh,TETmm,TETss]=autoFillTrain(folder)
%helps determining training start and end times automatically, based on the
%weather forecast data available

files = dir(folder);
removeFiles=find([files.bytes]==0);     %remove empty files
files(removeFiles)=[];

%Determine first and last available dates
D1=datestr(datenum([files(1).name(1:8) files(1).name(10:11)],'yyyymmddHH'));
D1=datetime(D1)+hours(1);
D2=datestr(datenum([files(end).name(1:8) files(end).name(10:11)],'yyyymmddHH'));
D2=datetime(D2);

%extract time information (year,month,...) separately
TSTd=day(D1);   TSTm=month(D1);   TSTy=year(D1);
TSThh=hour(D1);   TSTmm=minute(D1);   TSTss=second(D1);

TETd=day(D2);   TETm=month(D2);   TETy=year(D2);
TEThh=hour(D2);   TETmm=minute(D2);   TETss=second(D2);

end