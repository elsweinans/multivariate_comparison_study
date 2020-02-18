% function that calculates the performance of all indicators for all
% possible subsets of 2 to n-1 variables where n is the total number of
% variables in the system. Returns lowest kendall tau correlation for every
% indicator.

function lowestrhos=subset_data(data_input)   

    Lcs=size(data_input,3);
    nr_sims=size(data_input,4);
    nrvars=size(data_input,2);
    possvars=[];
    for i=2:nrvars-1
       possvars1=nchoosek(1:nrvars,i);
       possvars2=zeros(size(possvars1,1),nrvars-1);
       possvars2(:,1:size(possvars1,2))=possvars1;
       possvars=[possvars;possvars2];
    end    
    
    nrposs=size(possvars,1);
    meanrhos=zeros(nrposs,12);
    for k = 1:nrposs
        idx=possvars(k,:);
        data=data_input(:,idx(idx>0),:,:);
        pvalues=zeros(12,nr_sims);
        rhos=zeros(12,nr_sims);
        for i=1:nr_sims
           ind=MEWS(data(:,:,:,i)); 
           for j=1:12
              [rho,pval]=corr(ind(j,:)',[1:Lcs]','Type','Kendall'); 
              pvalues(j,i)=pval;
              rhos(j,i)=rho;
           end
        end
        meanrhos(k,:)=mean(rhos');
    end
    lowestrhos=min(meanrhos);
end