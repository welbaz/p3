function [tree] = PVtrain(Location,Pvsystem,t,UTC,WeatherforecastOrg, DiffMethod, Method)
%% time inputs
Starttime=t(1);
Endtime=t(end);
timestep=60;


%% Data aquiration (Clear Sky + AC Power)
PVClearsky=clearskygen(Pvsystem,Location,t,UTC);

AC_power=emoncms(1,320,Starttime,Endtime,timestep);
AC_power=AC_power(:,2)*1000; %%% kw to watts
 NanIndex=isnan(AC_power);

%%%% Acquire 1-10m%%%


% t1m=Starttime:minutes(timestep1m):Endtime;
% AC_power_1m=emoncms(1,320,Starttime,Endtime,timestep1m);
% AC_power_1m=AC_power_1m(:,2)*1000;
% PVClearsky_1m=clearskygen(Pvsystem,Location,t1m,UTC);
% ZeroIndex_1m=find(AC_power_1m==0);
% AC_power_1m(ZeroIndex_1m)=nan;
% NanIndex_1m=isnan(AC_power_1m);


%%Acquireforecastdata
%%%%%%%%%%%%%%
%%%Clean the data from Zeros and nans%%%


Weather_data=weatherset(WeatherforecastOrg,Starttime,Endtime,2,timestep);

% Weather_data_1m=weatherset(WeatherforecastOrg,Starttime,Endtime,2,timestep1m);
for i=1:length(PVClearsky)
if Weather_data(i,1)> 25 && Weather_data(i,3)==1
PVClearsky(i)=0.88*PVClearsky(i); %if Forecast-Temperature higher than 25 degree
                                  %efficiency of PV-System goes down
end
end
%%%%%
Weather_data(NanIndex,:)=nan;
%Weather_data_1m(NanIndex_1m,:)=nan;

%% Training
% DiffDataTypeday=[Weather_data_1m(:,3) AC_power_1m];
% % DiffDataTemp=[Weather_data_1m(:,1) PVClearsky_1m-AC_power_1m];
% DiffDataSky(NanIndex_1m,:)=[];
% DiffDataTemp(NanIndex_1m,:)=[];

if isequal(DiffMethod,'AbsoluteValues')
%%%%Normal Version%%%%%
    Diff = PVClearsky-AC_power;
elseif isequal(DiffMethod,'RelativeValues')
%%%%Relative Change%%%%
    Diff=(PVClearsky-AC_power)./PVClearsky;
    for i = 1 : length(Diff)
        if isnan(Diff(i)) || abs(Diff(i)) == inf
            Diff(i) = 0;
        end
    end
end
save('Diff.mat','Diff');


if isequal(Method,'GLM')
%%%%Generalized Linear Model%%%%
    tree=fitglm(Weather_data,Diff); %if used all tree commands MUST BE....
                                 %....UNCOMMENTED, NOT A TREE
elseif isequal(Method,'Forest')
%%%%Random Forest Regression Tree%%%%
    tree=TreeBagger(100,Weather_data,Diff,'Method','regression'); %if used ....
                                 %tree commands MUST BE UNCOMMENTED since
                                 %not a normal regressoin tree
else
%%%%Normal Regression Tree%%%%
    tree=fitrtree(Weather_data,Diff,'MinLeafSize',28);  %generate regression tree with constraint minimal leaf size of 28
end

if isequal(Method,'NormalTree')
    view(tree,'Mode','graph');  %tree command
end
%% Post-Processing and Visualization
figure;
plot(PVClearsky);
title('PVClearsky');
figure;
plot(AC_power);
title('AC_{power}');
figure;
plot(Diff);
title('Plot of Difference');
if isequal(Method,'NormalTree')
    imp = predictorImportance(tree);
    resuberror = resubLoss(tree);
end
%end

%%% Tree commands (must be uncommented when not normal regression tree is
%%% used
if isequal(Method,'GLM')==0
    leafs = logspace(1,2,10)
    rng('default')
    N = numel(leafs);
    err = zeros(N,1);
    for n=1:N
        tl = fitrtree(Weather_data,Diff,'CrossVal','On',...
            'MinLeafSize',leafs(n));
        err(n) = kfoldLoss(tl);
    end
    figure;
    plot(leafs,err);
    xlabel('Min Leaf Size');
    ylabel('cross-validated error');
end
%fitcnb(Weather_data,Diff)
end