function [bars,noises,meanrhos,stdrhos,meanps,stdps] = ...
    analysis_measurement_noise(data)



    %% noisy data with jumps
    % load('dataset_a0_jumps_20sims_015_045')
    % load('dataset_a10_jumps_20sims_015_045')

    % load('dataset_4D_rp-05_jumps_20sims')
    % load('dataset_4D_rp22_jumps_20sims.mat') 
    Lcs = size(data,3);

    %% noisy data no jumps
    % load('dataset_a0_noise_20sims_015_045')
    % load('dataset_a10_noise_20sims_015_045')

    % load('dataset_4D_rp-05_noise_20sims')
    % load('dataset_4D_rp22_noise_20sims')

    % Lcs=Lras;
    % cs=ras;

    %% analysis
    stepsnoise=200;
    data_old=data;
    noises=linspace(0.2,0.5,stepsnoise);
    meanrhos=zeros(12,stepsnoise);
    stdrhos=zeros(12,stepsnoise);
    meanps=zeros(12,stepsnoise);
    stdps=zeros(12,stepsnoise);
    nr_sims=size(data,4);

    pvalues=zeros(12,nr_sims,stepsnoise);
    rhos=zeros(12,nr_sims,stepsnoise);
    tic
    parfor k=1:stepsnoise;
        k
        noise=noises(k);

        data=data_old+normrnd(0,noise,size(data_old));


        for i=1:nr_sims
           ind=MEWS(data(:,:,:,i)); 
           for j=1:12
              [rho,pval]=corr(ind(j,:)',[1:Lcs]','Type','Kendall'); 
              pvalues(j,i,k)=pval;
              rhos(j,i,k)=abs(rho);
           end 
        end

    %     meanrhos(:,k)=mean(rhos(:,:,k)');
    %     stdrhos(:,k)=std(rhos(:,:,k)');
    %     meanps(:,k)=mean(pvalues(:,:,k)');
    %     stdps(:,k)=std(pvalues(:,:,k)');    
    end
    toc

    for k=1:stepsnoise
        meanrhos(:,k)=mean(rhos(:,:,k)');
        stdrhos(:,k)=std(rhos(:,:,k)');
        meanps(:,k)=mean(pvalues(:,:,k)');
        stdps(:,k)=std(pvalues(:,:,k)');      
    end

    bars=zeros(12,1);
    for i = 1:12
        ps=meanps(i,:);
        bars(i)=noises(min(find(ps>0.05)));
    end
end