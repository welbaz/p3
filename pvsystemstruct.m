function pvsystem=pvsystemstruct(ppeak,tilt,azimuth,eff,No_modules,Amodule)

pvsystem.powerpeak=ppeak;
pvsystem.tilt=tilt;
pvsystem.azimuth=azimuth;
pvsystem.eff=eff;
pvsystem.No_modules=No_modules;
pvsystem.Amodule=Amodule;
pvsystem.OArea=No_modules*Amodule;


end
