function [Distrib]=TrainPro(Data)
%this function produces the best fitting CDF for the data of
%each cloudness levels [0/8 1/8 ... 8/8]

Data=sortrows(Data);            %Sort due to Weather_Condition
%PDout=[];
j=1;
for i=1:9        %Search for probability distribution for all 9 cloudeness levels [0/8 ... 8/8]

[x]=find(Data(:,1)==i);     %Find all Data belonging to cloudness level x

if isempty(x)
    clear PD
    PD=NaN;        %if this cloudness level doesn't exist
    warning(['cloudness level ' num2str(x) '/8 is not available in trained data. ' ...
        'This will affect the quality of the prediction.'])
elseif ~any(~isnan(x(:)))
    clear PD
    PD=NaN;
    warning(['cloudness level ' num2str(x) '/8 is not available in trained data. ' ...
        'This will affect the quality of the prediction.'])
else
    Data10=Data(x,2);           %Get all Diff-Data belonging to Weather-Condition
    clear x D PD
    [D, PD] = allfitdist_woFig(Data10, 'CDF');    %allfitdist searches for best fitting CDF to the Data 
end

Distrib(j)=PD{1,1};
%PDout=[PDout; PD];
 j=j+1;
end
end
