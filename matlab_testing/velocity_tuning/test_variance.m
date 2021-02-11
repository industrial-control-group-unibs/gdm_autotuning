clear all
n=300;
A=10;
mu=2;
t=(1:n)';
x=A*ones(n,1);
x(mod(t,2)==0)=-x(mod(t,2)==0);
x=x+mu;
std(x)