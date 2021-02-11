syms Jm Bm Wc_vel Kp Ti

s=j*Wc_vel;

P=1/(Jm*s+Bm);
C=Kp*(1+1/Ti/s);

L=P*C;