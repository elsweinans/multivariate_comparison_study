clear all
close all
use threepatch_react
out N
a_analysis=0;
a=a_analysis;
if a==0
    mincs=1.6720; %0.7450;
    maxcs=2.08; %2.0400;
elseif a==10
    mincs=1.128; %0.1750;
    maxcs=1.6160; %1.5600;
end
Lcs=50;
cs=linspace(mincs,maxcs,Lcs);
Neqs=zeros(Lcs,3);
for i=1:Lcs
    c=cs(i);
    N=[5;5;5];
    time('-s')
    Neq=g_Y(end,:)';
    Neqs(i,:)=Neq;    
end

%%
use threepatch_react_noise_event2
out N
solver euler 0.001
simtime 1 1000 10100
a=a_analysis;
nr_sims=20;
data=zeros(10000,3,Lcs,nr_sims);
n=[0.02;0.02;0.02];
for j=1:nr_sims
    for i=1:Lcs
        N=[5;5;5];
        c=cs(i);
        collapsed=1;
        while collapsed==1
            [j i]
            Neq=Neqs(i,:)';
            S=time('-s','-r');    
            collapsed=any(S(end,2:end)<0.001);
        end
        data(:,:,i,j)=S(102:end,2:end);
    end
end

%save('dataset_a10_jumps_20sims_015_045')
    
%%
use threepatch_react_noise
out N
solver euler 0.001
simtime 1 1000 10100
a=a_analysis;
nr_sims=20;
data=zeros(10000,3,Lcs,nr_sims);
n=[0.02;0.02;0.02];
for j=1:nr_sims
    for i=1:Lcs
        N=[5;5;5];
        c=cs(i);
        collapsed=1;
        while collapsed==1
            [j i]
            Neq=Neqs(i,:)';
            S=time('-s','-r');    
            collapsed=any(S(end,2:end)<0.001);
        end
        data(:,:,i,j)=S(102:end,2:end);
    end
end

save('dataset_a0_noise_20sims_015_045')    
