function PVClearsky=clearskygen(Pvsystem,Location,t,UTC)

%% Main loop+
[m n]=size(t);
%PVout=zeros(n);
for i=1:n
Time=timestruct(t(i),UTC);
[PVout(i) Zenith(i)]=clearsky(Pvsystem,Location,Time); %generation of normal PV clearsky
    if Zenith(i) > 58.0362 && i>1 && Zenith(i-1)<=Zenith(i) 
        PVout(i)=0.4*PVout(i);
    end

end

PVClearsky=0.98*PVout'*Pvsystem.OArea*Pvsystem.eff; %take PV-system size and efficiency into acc.

end