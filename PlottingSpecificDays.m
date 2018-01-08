  %% Minutely
    date_frmt = 'dd-mmm-yyyy HH:MM:SS';
    beginTime='08-Aug-2016 00:00:00'; 
    endTime='10-Aug-2016 00:00:00'; 
    %%
    ts1=data2016mn;
    %ts1=ConvertResolution(ts1,'quarterhourly');
    %ts1=ConvertResolution(ts1,'halfhourly');
    ts1=ConvertResolution(ts1,'hourly');
    plot(ts1,'LineWidth',2)
    axes_handle = gca;
    %%
    set(axes_handle,'XLim', ... 
         [datenum(beginTime,date_frmt),datenum(endTime,date_frmt)],'FontSize',20,'LineWidth',2) 
    %set(gca,'FontSize',12,'LineWidth',1.25)
     ylabel('Power[Watt]')
     xlabel('Time')
     title('')
     datetick('x',15,'keeplimits')
     