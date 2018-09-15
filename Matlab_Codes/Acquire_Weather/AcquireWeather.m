
country='Germany';
city='Munich';
WeatherAPI= '00000000000000000';
AcqServer=['http://api.wunderground.com/api/' WeatherAPI '/hourly10day/q/'];
%%% Acquire data online
url=[AcqServer country '/' city '.json'];


contents = urlread(url);
data = parse_json(contents);


contents = urlread(url);
dataAstro = parse_json(contents);

%%%% Structuring it with the acquiring time for safety
DataOut=struct('acquiringTime',datetime('now'),'data',data,'Astro',dataAstro);

%%% Saving file
Dir='C:\Weather_Forecasts\';
filename=[Dir datestr(clock,30) '_hourlyforecast_10days.mat'];

save(filename,'DataOut')
