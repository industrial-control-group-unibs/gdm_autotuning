%%
Jm=0.00156872;
Bm=0;
Kp_gdm=0.1856;
Ti_gdm=5-3;
Wc=1129;

%
s=tf('s');

P=1/(Jm*s+Bm);

Kp=Kp_gdm*(60/2/pi);
Ti=Ti_gdm/1000.0;

C=Kp*(1+1/Ti/s);

margin(c2d(C*est,125e-3))
