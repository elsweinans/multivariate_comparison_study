clear all
rng('default')

load('dataset_4D_rp22_jumps_20sims.mat') 


indnames={'av AC','node maxAC','av var','node maxvar','maxcov','explvar',...
        'degfing','PCAvar','MAFeig','mafAC','MAFvar','absCC'};
%list of values based on their performance whilst getting measurement noise
[bars,noises,meanrhos,stdrhos,meanps,stdps] = analysis_measurement_noise(data);
performance_MN = eval_values(bars,1)


