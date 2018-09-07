function AcquireWeather(country, city, AcqServer, Dir)

%%% Acquire data online
url=[AcqServer country '/' city '.json'];
%url=['http://api.wunderground.com/api/50e9486ffd087d7d/hourly10day/q/' ...
%    country '/' city '.json']; 
%url='http://api.wunderground.com/api/50e9486ffd087d7d/hourly10day/q/Germany/Munich.json';
contents = urlread(url);
data = parse_json(contents);

%url='http://api.wunderground.com/api/50e9486ffd087d7d/astronomy/q/Germany/Munich.json';
contents = urlread(url);
dataAstro = parse_json(contents);
%%%% Structuring it with the acquiring time for safety
DataOut=struct('acquiringTime',datetime('now'),'data',data,'Astro',dataAstro);

%%% Saving file
%Dir='C:\Users\melda\Documents\Internship\New folder\'
filename=[Dir datestr(clock,30) '_hourlyforecast_10days.mat'];

save(filename,'DataOut')


