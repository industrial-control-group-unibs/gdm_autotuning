clear all;clc;close all
Out = OpenDriveConnection(38400);
% MaxPos=4;
% MaxVel=2000;
% set(Out.Modbus,'ParFloat',11004,0,MaxPos)
% set(Out.Modbus,'ParFloat',11002,0,MaxVel)
idx=1;
save_it=true;
disp('saving');
timer=tic;
while (true)        
    t(idx)=toc(timer);
    sm(idx,1)=get(Out.Modbus,'ParWord',12010,0);
    idx=idx+1;
    stairs(t,sm)
    pause(0.01)
end