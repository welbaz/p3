function dataout=missingData(datain,timestep,tref)
%%timestep=1 min;

tds=timestep/60/24;
t=datenum(unixtime(datain(:,1)));
indx=round((t-t(1))/tds) + 1;
dataout=[datenum(tref)' NaN(length(tref),1)];
dataout(indx,2)=datain(:,2);

if length(dataout)>length(tref)
    dataout(end,:)=[];
end

end