use plants_poll_4D_2

cp=[0.3 0.1;0.1 0.3];
ca=cp;
lap=[1 0.8;0.8 1];
lpa=lap;
% rp=[1.4 1.3]';
% ra=[-1.1 -1.2]' ;
% ra=-1.2;
% rp=1.3;

ra=-1.4500;
rp=2.2;
A=[3;3];
P=A;
out A P
time

stabil
eigen -r

time
Neq=g_Y(end,:);
nr_sims=250;
simtime 0 20 200

perts=normrnd(0,0.5,[4,nr_sims]);
perts=normc(perts);
figure
hold on
for i=[ 1:4 6:20]%nr_sims
   i
   A=Neq(1:2)+perts(1:2,i)';
   P=Neq(3:4)+perts(3:4,i)';
   time('-s')
   dist_to_eq=g_Y-Neq;
   normsS=sqrt(sum(dist_to_eq.^2,2));
   plot(normsS(1:100))    
end

%% rp-ra plot

%rps=-0.5:0.05:2.2;
rps=[-0.5 2.2];
Lrps=length(rps);
syst_TP=zeros(Lrps,1);
syst_react=zeros(Lrps,1);
ras=-0.05:-0.01:-3;
Lras=length(ras);
starteig=-0.45;
endeig=-0.15;

for j=1:Lrps
    j
    rp=rps(j);     
    eigsJ=zeros(Lras+1,1);
    eigsJ(1)=-1;
    eigsH=zeros(Lras+1,1);
    i=2;
    while eigsJ(i-1)<0
       ra=ras(i-1);
       A=[6 6]';
       P=[6 6]';
       stabil('-s');
       if min(A,P)<0.001 
           eigsJ(i)=1;
       else
           [J, eigenvalues, eigenvect] = i_eigen(1,1,[A;P]);
           eigsJ(i)=max(eigenvalues);
           H=(J+J')/2;
           eigsH(i)=max(eig(H));
       end  
       i=i+1;
    end
    eigsJ=eigsJ(2:end);
    eigsH=eigsH(2:end);
    syst_TP(j)=ras(min(find(eigsJ>0)));
    if all(eigsH<=0)
        syst_react(j)=nan;
    else
        syst_react(j)=ras(min(find(eigsH>0)));
    end
    if rp==-0.5 
        startsimrp05=ras(min(find(eigsJ>starteig)));
        endsimrp05=ras(min(find(eigsJ>endeig)));
    elseif rp==2.2
        startsimrp14=ras(min(find(eigsJ>starteig)));
        endsimrp14=ras(min(find(eigsJ>endeig))); 
    end    
end

figure
hold on
plot(rps,syst_react,'LineWidth',1.5)
plot(rps,syst_TP,'LineWidth',1.5)
plot([-0.5 -0.5],[startsimrp05 endsimrp05],'--k','LineWidth',3)
plot([2.2 2.2],[startsimrp14 endsimrp14],'--k','LineWidth',3,'HandleVisibility','off')
legend('system becomes reactive','tipping point','range 0.15-0.45')
% legend('system becomes reactive','tipping point')
xlabel('rp')
ylabel('ra')

%% Create data with jumps
use plants_poll_4D_jumps
out A P
simtime 1 1000 10100
cp=[0.3 0.1;0.1 0.3];
ca=cp;
lap=[1 0.8;0.8 1];
lpa=lap;
rp=-0.5;
if rp==2.2
    minra=-0.9100;
    maxra=-1.4500;
elseif rp==-0.5
    minra=-0.3;
    maxra=-0.68;
end
n=[0.02;0.02];

solver euler 0.001
simtime 1 1000 10100 %1000 10100

ras=linspace(minra,maxra,50); %50
Lras=length(ras);
nr_sims=20; %20
data=zeros(10000,4,Lras,nr_sims); %10000

for j=1:nr_sims
    for i=1:Lras
        A=[5;5];
        P=[5;5];
        ra=ras(i);
        collapsed=1;
        while collapsed==1
            [j i]
            S=time('-s','-r');    
            collapsed=any(S(end,2:end)<0.001);
        end
        data(:,:,i,j)=S(102:end,2:end);
    end
end

%save('dataset_4D_rp-05_jumps_20sims')

%% Create noisy data
use plants_poll_4D_jumps
out A P

simtime 1 1000 10100
cp=[0.3 0.1;0.1 0.3];
ca=cp;
lap=[1 0.8;0.8 1];
lpa=lap;
rp=-0.5;
if rp==2.2
    minra=-0.9100;
    maxra=-1.4500;
elseif rp==-0.5
    minra=-0.3;
    maxra=-0.68;
end
n=[0.02;0.02];

solver euler 0.001
simtime 1 1000 10100 %1000 10100

ras=linspace(minra,maxra,50); %50
Lras=length(ras);
nr_sims=20; %20
data=zeros(10000,4,Lras,nr_sims); %10000

for j=1:nr_sims
    for i=1:Lras
        A=[5;5];
        P=[5;5];
        ra=ras(i);
        collapsed=1;
        while collapsed==1
            [j i]
            S=time('-s','-r');    
            collapsed=any(S(end,2:end)<0.001);
        end
        data(:,:,i,j)=S(102:end,2:end);
    end
end

%save('dataset_4D_rp-05_noise_20sims')




