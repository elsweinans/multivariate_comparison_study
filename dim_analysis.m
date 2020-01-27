function [mean_dims,mean_total_vars]=dim_analysis(data,mean_dims,mean_total_vars)
    nr_sims=size(data,4);
    dims=zeros(nr_sims,1);
    total_variance=zeros(nr_sims,1);
    for i=1:nr_sims
        data1=data(:,:,end,i);
        C=cov(data1);
        [V,E]=eig(C);
        explvar=diag(E)/sum(diag(E));

        dims1=0;
        total_variance1=0;
        while total_variance1<0.9   
            total_variance1=total_variance1+max(explvar);
            explvar=explvar(find(explvar~=max(explvar)));   
            dims1=dims1+1;    
        end
        dims(i)=dims1;
        total_variance(i)=total_variance1;
    end
    mean_dims=[mean_dims mean(dims)];
    mean_total_vars=[mean_total_vars mean(total_variance)];
end