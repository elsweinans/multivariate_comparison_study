clear all
rng('default')
% load('dataset_a0_jumps_20sims_015_045')
% load('dataset_a10_jumps_20sims_015_045')

% load('dataset_4D_rp-05_jumps_20sims')
% load('dataset_4D_rp22_jumps_20sims.mat') 
% Lcs=Lras;
% cs=ras;

% load('dataset_a0_noise_20sims_015_045')
% load('dataset_a10_noise_20sims_015_045')

% load('dataset_4D_rp-05_noise_20sims')
load('dataset_4D_rp22_noise_20sims')
Lcs=Lras;
cs=ras;

stepsnoise=15;
data_old=data;
noises=linspace(0,1,stepsnoise);
meanrhos=zeros(12,stepsnoise);
stdrhos=zeros(12,stepsnoise);
meanps=zeros(12,stepsnoise);
stdps=zeros(12,stepsnoise);

for k=1:stepsnoise;
    
    noise=noises(k);
    
    data=data_old+normrnd(0,noise,size(data));

    pvalues=zeros(12,nr_sims);
    rhos=zeros(12,nr_sims);
    for i=1:nr_sims
       ind=MEWS(data(:,:,:,i)); 
       for j=1:12
          [rho,pval]=corr(ind(j,:)',[1:Lcs]','Type','Kendall'); 
          pvalues(j,i)=pval;
          rhos(j,i)=abs(rho);
       end 
    end
    
    meanrhos(:,k)=mean(rhos');
    stdrhos(:,k)=std(rhos');
    meanps(:,k)=mean(pvalues');
    stdps(:,k)=std(pvalues');    
end

bars=zeros(12,1);
for i = 1:12
    ps=meanps(i,:);
    bars(i)=noises(min(find(ps>0.05)));
end


indnames={'av AC','node maxAC','av var','node maxvar','maxcov','explvar',...
    'degfing','PCAvar','MAFeig','mafAC','MAFvar','absCC'}
figure
for i=1:12    
    subplot(6,2,i)
    errorbar(noises,meanrhos(i,:),stdrhos(i,:),'LineWidth',1.5)
    title(indnames(i))
    if i>10
        xlabel('std measurement noise')
    end
    if mod(i,2)==1
        ylabel('correlation')
    end
    ylim([0 1])
end

figure
for i=1:12    
    subplot(6,2,i)
    hold on
    errorbar(noises,meanps(i,:),stdps(i,:),'LineWidth',1.5)
    title(indnames(i))
    ylim([0 0.6])
    plot([0 max(noises)],[0.05 0.05],'--k','LineWidth',1.5 )
    if i>10
        xlabel('std measurement noise')
    end
    if mod(i,2)==1
        ylabel('p-value')
    end
end

indnames={'av AC','node maxAC','av var','node maxvar','maxcov','explvar',...
    'degfing','PCAvar','MAFeig','mafAC','MAFvar','absCC'}
figure
for i=1:12    
    subplot(6,2,i)
    plot(cs,ind(i,:)','LineWidth',1.5)
    title(indnames(i))
    if i>10
        xlabel('c')
    end
end

figure
bar(bars)
set(gca,'xticklabel',indnames)
% ticks=get(gca,'ytick');
% set(gca,'yticklabel',string(noises(1:max(ticks)+1)))
xtickangle(45)
ylabel('noise where trend becomes insignificant')



