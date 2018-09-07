function [PSTd,PSTm,PSTy,PSThh,PSTmm,PSTss,PETd,PETm,PETy,PEThh,PETmm,PETss]=autoFillPredict(folder)
%helps determining prediction start and end times automatically, based on the
%weather forecast data available

files = dir(folder);
removeFiles=find([files.bytes]==0);     %remove empty files
files(removeFiles)=[];

%Determine first and last available dates
D1=datestr(datenum([files(1).name(1:8) files(1).name(10:11)],'yyyymmddHH'));
D1=datetime(D1)+hours(1);
D2=datestr(datenum([files(end).name(1:8) files(end).name(10:11)],'yyyymmddHH'));
D2x=D2;
D2=datetime(D2)+days(7);

%if the current time is within available weather data
%(i.e. the weather data is up-to-date)
if datenum(now)<datenum(D2)
    PSTd=day(now+1);   PSTm=month(now+1);   PSTy=year(now+1);
    PSThh=0;   PSTmm=0;   PSTss=0;

    PETd=day(now+1);   PETm=month(now+1);   PETy=year(now+1);
    PEThh=23;   PETmm=59;   PETss=0;
end

%in case the user is working with past weather data
if datenum(now)>datenum(D2)
    PSTd=day(datenum(D2x)+1);   PSTm=month(datenum(D2x)+1);   PSTy=year(datenum(D2x)+1);
    PSThh=0;   PSTmm=0;   PSTss=0;

    PETd=day(datenum(D2x)+1);   PETm=month(datenum(D2x)+1);   PETy=year(datenum(D2x)+1);
    PEThh=23;   PETmm=59;   PETss=0;
end

end