function Diffp=GenPro(Distrib,Weather_input)

for i=1:length(Weather_input)
if Weather_input(i) > 9     
     Weather_input(i) = 9;   
 end                         
name=round(Weather_input(i));      %get for each timnestep desired weather-condition
if name == 0                %if no weather-condition availible set to 1
    name = 1;
end
    if isnan(Weather_input(i))      %if weather condition NaN set DIff to zeros
    Diffp(i,:)=zeros(1,9);
    
    else
        %inverse CDF
        Diffp(i,:)=icdf(Distrib(1,name),[0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9]); %Generate Diff values from weather condition and CDF
    end    
end
end
