clc;clear all;close all
tests={};
%tests{end+1}=load('test_1');
tests{end+1}=load('test_2');
tests{end+1}=load('test_3');
tests{end+1}=load('test_4');
tests{end+1}=load('test_5');
MaxPos=[];
MaxSpeed=[];
Jm=[];
Fc=[];
Bm=[];
labels={};
for idx=1:length(tests)
    MaxPos(idx,1)=tests{idx}.MaxPos(1);
    MaxSpeed(idx,1)=tests{idx}.MaxSpeed(1);
    Jm(idx,1)=mean(tests{idx}.Jm);
    stdJm(idx,1)=std(tests{idx}.Jm);
    Bm(idx,1)=mean(tests{idx}.Bm);
    stdBm(idx,1)=std(tests{idx}.Bm);
    Fc(idx,1)=mean(tests{idx}.Fc);
    stdFc(idx,1)=std(tests{idx}.Fc);
    labels(idx)={sprintf('%.0f rotations. %.0f RPM',MaxPos(idx),MaxSpeed(idx))};
%     MaxPos=[MaxPos;tests{idx}.MaxPos];
%     MaxSpeed=[MaxSpeed;tests{idx}.MaxSpeed];
%     Jm=[Jm;tests{idx}.Jm];
%     Fc=[Fc;tests{idx}.Fc];
%     Bm=[Bm;tests{idx}.Bm];

    
end

figure('Position',[63 1 1218 647.3333])
bar(Jm)
hold on
errorbar(1:length(tests),Jm,stdJm,'ok','CapSize',130)
xticklabels(labels)
xtickangle(45)
ylabel('Inertia')
export_fig('Inertia_id')

figure('Position',[63 1 1218 647.3333])
bar(Bm)
hold on
errorbar(1:length(tests),Bm,stdBm,'ok','CapSize',130)
xticklabels(labels)
xtickangle(45)
ylabel('Viscous friction')
export_fig('Viscous_id')

figure('Position',[63 1 1218 647.3333])
bar(Fc)
hold on
errorbar(1:length(tests),Fc,stdFc,'ok','CapSize',130)
xticklabels(labels)
xtickangle(45)
ylabel('Coulomb friction')
export_fig('Coulomb_id')
