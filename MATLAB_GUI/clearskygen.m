function PVClearsky=clearskygen(Pvsystem,Location,t,UTC)

%% Main loop+
[m n]=size(t);
%PVout=zeros(n);
for i=1:n
    % Create a time structure
    dummy=datevec(t);
    Time.year=dummy(i,1);
    Time.month=dummy(i,2);
    Time.day=dummy(i,3);
    Time.hour=dummy(i,4);
    Time.minute=dummy(i,5);
    Time.second=dummy(i,6);
    Time.UTC=UTC;
    
    [PVout(i) Zenith(i)]=clearsky(Pvsystem,Location,Time); %generation of normal PV clearsky
    

    if Zenith(i) > 58.0362 && i>1 && Zenith(i-1)<=Zenith(i) 
        PVout(i)=0.56*PVout(i);
    end
end

PVClearsky=0.98*PVout'*Pvsystem.OArea*Pvsystem.eff; %take PV-system size and efficiency into acc.
%plot(PVClearsky)

end

%%58.0362