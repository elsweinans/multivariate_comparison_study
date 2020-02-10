clear all
rng('default')

% load('dataset_a0_noise_20sims_015_045')
% load('dataset_a10_noise_20sims_015_045')

load('dataset_4D_rp-05_noise_20sims')
% load('dataset_4D_rp22_noise_20sims')

Lcs=Lras;
cs=ras;

stepslength=1000;
data_old=data;
lengths=linspace(10,size(data_old,1),stepslength);
meanrhos=zeros(12,stepslength);
stdrhos=zeros(12,stepslength);
meanps=zeros(12,stepslength);
stdps=zeros(12,stepslength);

indnames={'av AC','node maxAC','av var','node maxvar','maxcov','explvar',...
    'degfing','PCAvar','MAFeig','mafAC','MAFvar','absCC'};

parfor k=1:stepslength;
    k
    l=round(lengths(k));
    
    data=data_old(end-(l-1):end,:,:,:);

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
    
    figure(1)
    for i=1:12    
        subplot(6,2,i)
        plot(cs,ind(i,:)','LineWidth',1.5)
        set ( gca, 'xdir', 'reverse' )
        title(indnames(i))
        if i>10
            xlabel('c')
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
    bars(i)=lengths(max(find(ps>0.05)));
end

figure
for i=1:12    
    subplot(6,2,i)
    errorbar(lengths,meanrhos(i,:),stdrhos(i,:),'LineWidth',1.5)
    title(indnames(i))
    if i>10
        xlabel('data length')
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
    errorbar(lengths,meanps(i,:),stdps(i,:),'LineWidth',1.5)
    title(indnames(i))
    ylim([0 0.6])
    plot([0 max(lengths)],[0.05 0.05],'--k','LineWidth',1.5 )
    if i>10
        xlabel('data length')
    end
    if mod(i,2)==1
        ylabel('p-value')
    end
end

% figure
% for i=1:12    
%     subplot(6,2,i)
%     plot(cs,ind(i,:)','LineWidth',1.5)
%     set ( gca, 'xdir', 'reverse' )
%     title(indnames(i))
%     if i>10
%         xlabel('c')
%     end
% end

fig=figure
subplot(2,1,1,'Position',[0.15 0.57 0.8 0.38])
bar(bars)
ylim([500 7200])
subplot(2,1,2,'Position',[0.15 0.17 0.8 0.38])
bar(bars)
ylim([0 110])
set(gca,'xticklabel',indnames)
xtickangle(45)
han=axes(fig,'visible','off'); 
han.YLabel.Visible='on';
han.YLabel.Position(1)=-0.09
ylabel(han,'length where signal becomes significant');







