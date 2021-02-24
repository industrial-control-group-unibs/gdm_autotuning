clear all;clc;close all
Motor = OpenDriveConnection(38400,'7'); 
%Load = OpenDriveConnection(38400,'4');
% MaxPos=4;
% MaxVel=2000;
% set(Out.Modbus,'ParFloat',11004,0,MaxPos)
% set(Out.Modbus,'ParFloat',11002,0,MaxVel)
save_it=true;
disp('saving');

friction=logspace(-3,-1,10)';
idx=1;
while true       
        
    sm=get(Motor.Modbus,'ParWord',12010,0);
    if and(sm==15,save_it)
        disp('one')
        MaxTorque( idx,1)=get(Motor.Modbus,'ParFloat',11000,0);
        MaxSpeed( idx,1)=get(Motor.Modbus,'ParFloat',11002,0);
        MaxPos(idx,1)=get(Motor.Modbus,'ParFloat',11004,0);
        
        Jm( idx,1)=get(Motor.Modbus,'ParFloat',12012,0);
        Fc(idx,1)=get(Motor.Modbus,'ParFloat',12014,0);
        Bm(idx,1)=get(Motor.Modbus,'ParFloat',12016,0);
        Kp(idx,1)=get(Motor.Modbus,'ParFloat',12018,0);
        Ti(idx,1)=get(Motor.Modbus,'ParFloat',12020,0);
        Wc(idx,1)=get(Motor.Modbus,'ParFloat',12022,0);
        idx=idx+1;
        save_it=false;
        figure(1)
        subplot(3,1,1)
        stem(Jm)
        ylabel('Jm')
        subplot(3,1,2)
        stem(Fc)
        ylabel('Fc')
        subplot(3,1,3)
        stem(Bm)
        hold on
        stem(friction)
        ylabel('Bm')
        figure(2)
        subplot(3,1,1)  
        stem(Kp);
        ylabel('Kp')
        subplot(3,1,2)
        stem(Ti);
        ylabel('Ti')
        subplot(3,1,3)
        stem(Wc);
        ylabel('Wc')
    elseif sm==0
        save_it=true;
    end
    pause(0.01)
end