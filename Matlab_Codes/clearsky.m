function [Pclearsky Zenith] = clearsky(Pvsystem,Location,Time)

%%Input Variables
% Pclearsky is the maximum power generated in cloudless environment
% ppeak is the maximum power of the installed pvsystem
% tday is time of the year , hour of the year to be done

%%Model Constants
S0=1367; % Solar constant
Ozonecm=0.3; %cm
Pressure=1012; %mb
H2Ocm=1.5;
Taua=0.08;
Ba=0.85;
Albedo=0.2;

%%Time Setup
dvec=[Time.year Time.month Time.day Time.hour Time.minute Time.second];
dvecref=dvec;
dvecref(:,2:3)=0;
dayoyear=cat(2, dvec(:, 1), datenum(dvec) - datenum(dvecref));
houroday = Time.hour + Time.minute./60 + Time.second./3600;

%Refday = dayoyear(2) + floor((houroday + (Time.UTC*-1))/24);
%Refhour = mod((houroday+ (Time.UTC*-1)), 24);
Julianday=juliandate(datetime(dvec));
Juliancentury=(Julianday-2451545)/36525;
Refday = dayoyear(2) + floor((houroday)/24);
Refhour = mod((houroday), 24);

%%Basic Sun Calculations
Geom_mean_long_sun=mod(280.46646+Juliancentury*(36000.76983 + Juliancentury*0.0003032),360); % Validated
Geom_mean_anom_sun=357.52911+Juliancentury*(35999.05029 - 0.0001537*Juliancentury);%Validated
Earthorbit=0.016708634-Juliancentury*(0.000042037+0.0000001267*Juliancentury); %Validated
Suneqofctr=sin(Geom_mean_anom_sun*pi/180)*(1.914602-Juliancentury*(0.004817+0.000014*Juliancentury))+sin(Geom_mean_anom_sun*2*pi/180)*(0.019993-0.000101*Juliancentury)+sin(Geom_mean_anom_sun*3*pi/180)*0.000289; % Validated
Suntruelong=Suneqofctr+Geom_mean_long_sun; % Valid
Sunapplong=Suntruelong-0.00569-0.00478*sin((125.04-1934.136*Juliancentury)*pi/180); % validated
Mean_obliq_ecliptic=23+(26+((21.448-Juliancentury*(46.815+Juliancentury*(0.00059-Juliancentury*0.001813))))/60)/60;
Obliqcorr=Mean_obliq_ecliptic+0.00256*cos((125.04-1934.136*Juliancentury)*pi/180); % valid
vary=tan(Obliqcorr*pi/(2*180))^2; % valid
Eqoftime=4*180*(vary*sin(2*Geom_mean_long_sun*pi/180)-2*Earthorbit*sin(Geom_mean_anom_sun*pi/180)+4*Earthorbit*vary*sin(Geom_mean_anom_sun*pi/180)*cos(2*Geom_mean_long_sun*pi/180)-0.5*vary*vary*sin(4*Geom_mean_long_sun*pi/180)-1.25*Earthorbit*Earthorbit*sin(2*Geom_mean_anom_sun*pi/180))/pi;
Truesolartime=mod(((Time.hour+(Time.minute/60))/24)*1440+Eqoftime+4*Location.longitude-60*Time.UTC,1440);
%%Solar Geometry Calculations
ETR=S0-2*(1.00011+0.034221*cos(2*pi*(Refday-1)/365.25)+0.00128*sin(2*pi*(Refday-1)/365.25)+0.000719*cos(2*(2*pi*(Refday-1)/365.25))+0.000077*sin(2*(2*pi*(Refday-1)/365.25)));
Dangle=2*pi*(Refday-1)/365.25;
%DEC=(0.006918-0.399912*cos(Dangle)+0.070257*sin(Dangle)-0.006758*cos(2*Dangle) +0.000907*sin(2*Dangle)-0.002697*cos(3*Dangle)+0.00148*sin(3*Dangle))*(180/pi);
%DEC=asin(sin(23.45)*sin((360/365)*(Refday-82)))*180/pi;
DEC=(asin(sin(Obliqcorr*pi/180)*sin(Sunapplong*pi/180)))*180/pi;
EQT=(0.0000075+0.001868*cos(Dangle)-0.032077*sin(Dangle)-0.014615*cos(2*Dangle) -0.040849*sin(2*Dangle))*(229.18);
%HourAngle=15*(Time.hour-12.5)+(Location.longitude)-(Time.UTC)*15+EQT/4;
if Truesolartime/4 <0
    HourAngle=(Truesolartime/4) + 180;
else
    HourAngle=(Truesolartime/4) - 180;
end
Zenith=acos(cos(DEC/(180/pi))*cos(Location.latitude/(180/pi))*cos(HourAngle/(180/pi))+sin(DEC/(180/pi))*sin(Location.latitude/(180/pi)))*(180/pi);
Elevation=90-Zenith;
%Azimuth= acos(((sin(DEC)*cos(Location.latitude/(180/pi)))-(cos(HourAngle)*cos(DEC)*cos(Location.latitude/(180/pi))))/sin(Zenith))


%%Bird Model
if Zenith < 89
Airmass = 1/(cos(Zenith/(180/pi))+0.15/(93.885-Zenith)^1.25);
else
Airmass= 0;
end

if Airmass >0
    Trayleight=exp(-0.0903*(Pressure*Airmass/1013)^0.84*(1+Pressure*Airmass/1013-(Pressure*Airmass/1013)^1.01));
    Tozone=1-0.1611*(Ozonecm*Airmass)*(1+139.48*(Ozonecm*Airmass))^-0.3034-0.002715*(Ozonecm*Airmass)/(1+0.044*(Ozonecm*Airmass)+0.0003*(Ozonecm*Airmass)^2);
    Tgas=exp(-0.0127*(Airmass*Pressure/1013)^0.26);
    Twater=1-2.4959*Airmass*H2Ocm/((1+79.034*H2Ocm*Airmass)^0.6828+6.385*H2Ocm*Airmass);
    Taersol=exp(-(Taua^0.873)*((1+Taua)-(Taua^0.7088))*Airmass^0.9108);
    TAA=1-0.1*(1-Airmass+Airmass^1.06)*(1-Taersol);
    rs=0.0685+(1-Ba)*(1-Taersol/TAA);
    Id=0.9662*ETR*Taersol*Twater*Tgas*Tozone*Trayleight;
    IdnH=Id*cos(Zenith/(180/pi));
    Ias=ETR*cos(Zenith/(180/pi))*0.79*Tozone*Tgas*Twater*TAA*(0.5*(1-Trayleight)+Ba*(1-(Taersol/TAA)))/(1-Airmass+(Airmass)^1.02);
    GH=(IdnH+Ias)/(1-Albedo*Taersol);
else
   Tozone=0;
   Tgas=0;
   Twater=0;
   Taersol=0;
   TAA=0;
   rs=0;
   Id=0;
   Ias=0;
   IdnH=0;
   GH=0;
end
 if HourAngle > 0
     
    Azimuth=mod((acos(((sin(Location.latitude*pi/180))*cos(Zenith*pi/180)-sin(DEC*pi/180))/(cos(Location.latitude*pi/180)*sin(Zenith*pi/180)))*180/pi)+180,360);
 else
    Azimuth=mod(540-(acos(((sin(Location.latitude*pi/180))*cos(Zenith*pi/180)-sin(DEC*pi/180))/(cos(Location.latitude*pi/180)*sin(Zenith*pi/180)))*180/pi),360);
 end
%% PV System Orientation and calculation


 if Zenith<71.65
     
         IdnH=Id*cos(Zenith*pi/180);
         Idmodule=Id*(cos(Elevation*pi/180)*sin(Pvsystem.tilt*pi/180)*cos((Pvsystem.azimuth-Azimuth)*pi/180)+(sin(Elevation*pi/180)*cos(Pvsystem.tilt*pi/180)));
 else
          IdnH=0;
          Idmodule=0;
 end

 
Pclearsky=Idmodule;
