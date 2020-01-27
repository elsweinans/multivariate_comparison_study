load('dataset_a0_jumps_20sims_015_045')
%load('dataset_a10_jumps_20sims_015_045')

% load('dataset_4D_rp-05_jumps_20sims')
% load('dataset_4D_rp22_jumps_20sims.mat') 
% Lcs=Lras;
% cs=ras;

pvalues=zeros(14,nr_sims);
rhos=zeros(14,nr_sims);
for i=1:nr_sims
   ind=MEWS(data(:,:,:,i)); 
   for j=1:14
      [rho,pval]=corr(ind(j,:)',[1:Lcs]','Type','Kendall'); 
      pvalues(j,i)=pval;
      rhos(j,i)=rho;
   end
end

indnames={'av AC','node maxAC','av var','node maxvar','maxcov','explvar',...
    'degfing','PCAvar','MAFeig','MAF AC','MAFvar','absCC','PS PCA', 'PS MAF'};
figure
for i=1:14    
    subplot(7,2,i)
    plot(cs,ind(i,:)','LineWidth',1.5)
    title(indnames(i))
    if i>10
        xlabel('c')
    end

end

figure
bar(abs(mean(rhos')))
hold on
errorbar(abs(mean(rhos')),std(rhos'),'k','LineStyle','none')
ylim([0 1])
set(gca,'xticklabel',indnames)
xtickangle(45)

%% Testing for subsets of data

pvalues=zeros(12,nr_sims);
rhos=zeros(12,nr_sims);
for i=1:nr_sims
   ind=MEWS(data(:,[2 3],:,i));  %[1 2], [1 3] or [2 3]
   for j=1:12
      [rho,pval]=corr(ind(j,:)',[1:Lcs]','Type','Kendall'); 
      pvalues(j,i)=pval;
      rhos(j,i)=rho;
   end
end

figure
bar(abs(mean(rhos')))
hold on
errorbar(abs(mean(rhos')),std(rhos'),'k','LineStyle','none')
ylim([0 1])
set(gca,'xticklabel',indnames)
xtickangle(45)