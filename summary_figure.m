clear all
rng('default')

load('dataset_4D_rp22_jumps_20sims.mat') 


indnames={'av AC','node maxAC','av var','node maxvar','maxcov','explvar',...
        'degfing','PCAvar','MAFeig','mafAC','MAFvar','absCC'};
%list of values based on their performance whilst getting measurement noise
[bars,noises,meanrhos,stdrhos,meanps,stdps] = analysis_measurement_noise(data);
performance_MN = eval_values(bars,2)
lowestrhos=subset_data(data);
performance_SV = eval_values(lowestrhos,2)

aver_perf=[performance_MN performace_SV]

figure
pcolor(aver_perf)
yticks([1.5:1:12.5])
yticklabels(indnames)
xticks(1.5:1:2.5)
xticklabels({'meas noise','subset vars'})
xtickangle(45)
hcb=colorbar
colorTitleHandle = get(hcb,'Title');
titleString = 'performance';
set(colorTitleHandle ,'String',titleString);
colormap(gray)

