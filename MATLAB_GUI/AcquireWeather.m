function AcquireWeather(country, city, AcqServer, Dir)

%%% Acquire data online
url=[AcqServer country '/' city '.json'];


contents = urlread(url);
data = parse_json(contents);

contents = urlread(url);
dataAstro = parse_json(contents);
%%%% Structuring it with the acquiring time for safety
DataOut=struct('acquiringTime',datetime('now'),'data',data,'Astro',dataAstro);

%%% Saving file
%Dir='C:\Users\melda\Documents\Internship\New folder\'
filename=[Dir datestr(clock,30) '_hourlyforecast_10days.mat'];

save(filename,'DataOut')


