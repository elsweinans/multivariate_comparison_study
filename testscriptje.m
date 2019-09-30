cd C:\Users\weina005\Dropbox\mult_proj
clear all
close all
use threepatch_react
out N

as=0:0.1:7;
cs=0:0.005:3;
Las=length(as);
Lcs=length(cs);
syst_react=zeros(Las,1);
syst_TP=zeros(Las,1);

for i=1:Las
    [i Las]
    a=as(i);
    eigsJ=zeros(30,1);
    eigsH=zeros(30,1);
    j=2;
    eigsJ([1:2])=[-1 -1];
    eigsH([1:2])=[-1 -1];
    while eigsJ(j-1)<0
        N=[5;5;5];
        c=cs(j);
        N=findeq('Display','off');
        [J, eigenvalues, eigenvect] = i_eigen(1,1,N);
        eigsJ(j)=max(eigenvalues);
        H=(J+J')/2;
        eigH=eig(H);
        eigsH(j)=max(eigH);  
        j=j+1; 
    end 
    syst_react(i)=cs(min(find(eigsH>0)));
    syst_TP(i)=cs(min(find(eigsJ>0)));       
end
%save('datafig190926_react_tipping')
%load('datafig190926_react_tipping')

figure
plot(as,syst_react,'LineWidth',1.5)
hold on
plot(as,syst_TP,'LineWidth',1.5)
legend('system becomes reactive','tipping point')
xlabel('a')
ylabel('e')
ylim([0 max([max(syst_react) max(syst_TP)])])





















