clear all;close all;clc;
Motor = OpenDriveConnection(38400,'3'); 
%%
Jm=get(Motor.Modbus,'ParFloat',12012,0);
Fc=get(Motor.Modbus,'ParFloat',12014,0);
Bm=get(Motor.Modbus,'ParFloat',12016,0);
Kp_gdm=get(Motor.Modbus,'ParFloat',12018,0);
Ti_gdm=get(Motor.Modbus,'ParFloat',12020,0);
Wc=get(Motor.Modbus,'ParFloat',12022,0);

Bm=max(0,Bm);
%
s=tf('s');

P=1/(Jm*s+Bm);

Kp=Kp_gdm*(60/2/pi);
Ti=Ti_gdm/1000.0;

C=Kp*(1+1/Ti/s);

margin(C*P)
clear Motor