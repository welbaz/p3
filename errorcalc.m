function [error] = errorcalc(predicted,measured)
%% Nancheck
Nancheck = ~isnan(measured) & ~isnan(predicted);
predicted= predicted(Nancheck);
measured = measured(Nancheck);

%% Error Type 1: Power Error
delta=abs(predicted - measured);
% ZeroIndex=find(PVClearsky==0);
% PVClearsky(ZeroIndex)=nan;
Per_error=delta ./ measured;
meanPerc=nanmean(Per_error)*100;

%% Error Type 2: (RMSE)
RMSE= sqrt( sum( (measured(:)-predicted(:)).^2) / numel(measured)); 

%% Error Type 3: Mean Absolute Error MAE
MAE=sum(abs(measured(:)-predicted(:)))/ numel(measured);  

%% Error Type 4: Mean Biased Error MBE
MBE=sum(measured(:)-predicted(:))/ numel(measured);  

%% Error Type 5: SDE Standard deviation
e=measured(:)-predicted(:);
edash=mean(e);
SDE=sqrt( sum( (e(:)- edash).^2)/ (numel(measured)-1));
%% Error Type 3: (rRMSE)
 
%%Error Type 4: (wrRMSE)

wrmse=sqrt( sum( (e.*measured./max(measured)).^2) / numel(measured));
%%% Output

error=struct('meanPerc', meanPerc, 'RMSE', RMSE, 'wrRMSE',wrmse, 'MAE', MAE, 'MBE',MBE,'SDE',SDE);

end

