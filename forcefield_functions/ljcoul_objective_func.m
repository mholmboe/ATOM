function res = ljcoul_objective_func(param,data,r,scalefactors,varargin)

param=param./scalefactors;

q1=param(1);
q2=param(2);

sig1=param(3);
sig2=param(4);

eps1=param(5);
eps2=param(6);

e_mix=(eps1*eps2)^.5;
sig_mix=(sig1+sig2)/2;

lj=4*e_mix.*((sig_mix./r).^12-(sig_mix./r).^6);
coul=(1.60217646E-19)^2*6.022E+23*q1*q2./(r*1E-9)*1/(4*3.14159*8.85E-12)/1000;
Utot=lj+coul;

res=data-Utot;
