function [Weather_data]=weatherset(WeatherforecastOrg,Starttime,Endtime,lag,timestep)

Weatherforecast=getsampleusingtime(WeatherforecastOrg,datenum(Starttime),datenum(Endtime));

%Weatherforecast.sky.Data =  Weatherforecast.sky.Data ./100;
%Weatherforecast.wspd.Data= Weatherforecast.wspd.Data ./max(max(Weatherforecast.wspd.Data));
if timestep<60
    Weatherforecast=resample(Weatherforecast,datestr(Starttime:minutes(timestep):Endtime));
end

Weather_data=[ Weatherforecast.temp.Data(:,10) Weatherforecast.sky.Data(:,10) Weatherforecast.cond.Data(:,10)]; %best case weather is used
%Weather_data=[ Weatherforecast.temp.Data(:,10) Weatherforecast.sky.Data(:,10) Weatherforecast.Humidity.Data(:,10) Weatherforecast.wspd.Data(:,10)  Weatherforecast.wdir.Data(:,10) Weatherforecast.wx.Data(:,10) Weatherforecast.cond.Data(:,10)]
Weather_data=[ Weatherforecast.temp.Data(:,1) Weatherforecast.sky.Data(:,1) Weatherforecast.cond.Data(:,1)]; %worst case weather is used


% For 10 day prediction when for each day the according weatherforecast...
% ...should be used
% if round(datenum(Endtime)-datenum(Starttime)) == 10
%     for day = 1:10
%         Weather_data(1+24*day-24:24*day,:)=[ Weatherforecast.temp.Data(1+24*day-24:24*day,11-day) Weatherforecast.sky.Data(1+24*day-24:24*day,11-day) Weatherforecast.cond.Data(1+24*day-24:24*day,11-day)];
%     end
% end

if lag>0
    Weather_data=Weather_data(1+lag:end,:);
Weather_data(end:end+lag,:)=0;
elseif lag<0
        dummy=zeros(size(Weather_data));
        dummy(abs(lag)+1:end,:)=Weather_data(1:end-abs(lag),:);
	    Weather_data=dummy;
end

end