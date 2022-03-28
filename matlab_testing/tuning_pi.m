clear all;clc;
Jm=0.0010;
Jc=0.0005;
k=1000;
h=0.05;
hm=.0015;
model=ElasticSystemModel(Jm,Jc,k,h,hm);
sys=minreal(model(3,1));
s=tf('s');
model=1/((Jm+Jc)*s+hm);
%%
%bode(model,sys)
st=1e-3;
wc=400;
Bm=hm;
J=Jm+Jc;
phi=deg2rad(75);
faseP=-wc*st/2 + -atan2(J*wc,Bm);
% atan(Ti*w,1)-pi/2+faseP=-pi+phi
% pi/2+faseP=-pi/2+phi
% faseP=-pi+phi
% -wc*st/2 =atan2(J*wc,Bm)-pi+phi
% -wc*st/2 =pi/2-pi+phi
% -wc*st/2 =-pi/2+phi
wcmax=2/st * (pi/2-phi);
% tan(-pi/2+phi-faseP)/w
if (-pi/2+phi-faseP)<0
    error('wc too high')
elseif ((-pi/2+phi-faseP))>pi/2
    error('wc too high')
end
ti_v=tan(-pi/2+phi-faseP)/wc;
kp_v=(ti_v*wc*sqrt(Bm^2 + J^2*wc^2))/sqrt(ti_v^2*wc^2 + 1.0);
C=kp_v*(1+1/ti_v/s);
sys=c2d(sys,st);
C=c2d(C,st);
model=c2d(model,st);
%%
figure(1)
margin(C*model)
hold on
bode(C*model)
hold off
figure(2)
subplot(2,2,1)
step(feedback(sys*C,1))
subplot(2,2,3)
step(feedback(C,sys))
subplot(2,2,2)
step(feedback(sys,C))
subplot(2,2,4)
step(-feedback(C*sys,1))