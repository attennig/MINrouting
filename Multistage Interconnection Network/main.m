clc;
clear all;
n = 4;
perm = randperm(2^n)-1;

but = ButterflyNetwork(n);
but.selfRouting(perm);
but.draw();

bas = BaselineNetwork(n);
bas.selfRouting(perm);
bas.draw();