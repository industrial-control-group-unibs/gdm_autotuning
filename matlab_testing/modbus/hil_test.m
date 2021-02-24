clc;clear all;close all
load test_hil.mat

Bm_no_load=0.0075; % from no load test


plot(friction+Bm_no_load)
hold on
plot(Bm)
xlabel('Test')
ylabel('Viscous friction')
legend('HIL viscous friction','Estimated viscous friction');
grid on

