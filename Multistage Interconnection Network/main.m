clc;
clear all;
n = 4;
perm = randperm(2^n)-1;
%perm = [8,10,6,12,4,14,2,0,1,15,3,13,5,11,7,9]
but = ButterflyNetwork(n);
but.selfRouting(perm);
but.draw();

bas = BaselineNetwork(n);
bas.selfRouting(perm);
bas.draw();