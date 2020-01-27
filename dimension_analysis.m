clear all
close all

mean_dims=[];
mean_total_vars=[];
load('dataset_4D_rp-05_jumps_20sims') 
[mean_dims,mean_total_vars]=dim_analysis(data,mean_dims,mean_total_vars);
load('dataset_4D_rp22_jumps_20sims.mat') 
[mean_dims,mean_total_vars]=dim_analysis(data,mean_dims,mean_total_vars);
load('dataset_a0_jumps_20sims.mat')
[mean_dims,mean_total_vars]=dim_analysis(data,mean_dims,mean_total_vars);
load('dataset_a10_jumps_40sims.mat') 
[mean_dims,mean_total_vars]=dim_analysis(data,mean_dims,mean_total_vars);

models={'PP non-react','PP react','MP non-react','MP react'} 
figure
bar(mean_dims)
set(gca,'xticklabel',models)
ylabel('dimensionality')

figure
bar(mean_total_vars)
set(gca,'xticklabel',models)
ylabel('explvar')
