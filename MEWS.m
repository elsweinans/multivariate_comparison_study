% Function takes time series (can be window) as input and calculates the
% average AC, the AC on the node with the highest AC, the average variance,
% the variance of the node with the highest variance, the maximum value
% of the covariance matrix, the explained variance of the covariance
% matrix, the AC of the data projection on the first PC (degenerate
% fingerprinting), the variance of the data projection on the first PC
% (maximum variance), the MAF eigenvalue, the AC of the data projection on
% the first MAF (maximum AC), the variance of the data projection on the
% first MAF and the sum of the absolute values of all cross-correlations.


% function ind=MEWS(data)
%     dims=size(data,3);
%     nr_variables=size(data,2);
%     ind=zeros(12,dims);
%     for j=1:dims  
%         TS=data(:,:,j);
%         ARs=zeros(nr_variables,1);
%         vars=zeros(nr_variables,1);
%         for i=1:nr_variables
%             ARs(i)=corr(TS(1:end-1,i),TS(2:end,i));
%             vars(i)=var(TS(:,i));
%         end
%         ind(1,j)=mean(ARs); %average AC
%         ind(2,j)=max(ARs); %AC of node with highest AC
%         ind(3,j)=mean(vars); %average var
%         ind(4,j)=max(vars); %var of node with higest var
%         C=cov(TS);
%         ind(5,j)=max(C(:)); %max value cov matrix
%         [V,E]=eig(C);
%         ind(6,j)=max(diag(real(E))); %explained variance
%         idx=find(diag(E)==ind(6,j));
%         proj=TS*(V(:,idx));
%         ind(7,j)=corr(proj(1:end-1),proj(2:end)); %degenerate fingerprinting
%         ind(8,j)=var(proj); %maximum variance in system
%         [Wmaf K]=MAF(TS);
%         K=diag(K)/sum(diag(K));
%         ind(9,j)=min(K); %MAF eigenvalue
%         proj2=TS*Wmaf(:,1);
%         ind(10,j)=corr(proj2(1:end-1),proj2(2:end)); %maximum AC in system
%         ind(11,j)=var(proj2); %var on 1st MAF
%         CM=corrcoef(TS);
%         CM=tril(CM,-1);
%         ind(12,j)=sum(abs(CM(:))); %sum of absolute values of cross-correlation
%     end    
% end

function ind=MEWS(data)
    dims=size(data,3);
    nr_variables=size(data,2);
    ind=zeros(14,dims);
    for j=1:dims  
        TS=data(:,:,j);
        ARs=zeros(nr_variables,1);
        vars=zeros(nr_variables,1);
        for i=1:nr_variables
            ARs(i)=corr(TS(1:end-1,i),TS(2:end,i));
            vars(i)=var(TS(:,i));
        end
        ind(1,j)=mean(ARs); %average AC
        ind(2,j)=max(ARs); %AC of node with highest AC
        ind(3,j)=mean(vars); %average var
        ind(4,j)=max(vars); %var of node with higest var
        C=cov(TS);
        ind(5,j)=max(C(:)); %max value cov matrix
        [V,E]=eig(C);
        E=diag(real(E))/sum(diag(real(E)));
        ind(6,j)=max(E); %explained variance
        idx=find(E==ind(6,j));
        proj=TS*(V(:,idx));
        ind(7,j)=corr(proj(1:end-1),proj(2:end)); %degenerate fingerprinting
        ind(8,j)=var(proj); %maximum variance in system
        [Wmaf K]=MAF(TS);
        K=diag(K)/sum(diag(K));
        ind(9,j)=min(K); %MAF eigenvalue
        proj2=TS*Wmaf(:,1);
        ind(10,j)=corr(proj2(1:end-1),proj2(2:end)); %maximum AC in system
        ind(11,j)=var(proj2); %var on 1st MAF
        CM=corrcoef(TS);
        CM=tril(CM,-1);
        ind(12,j)=sum(abs(CM(:))); %sum of absolute values of cross-correlation
        
        Y=fft(proj);
        L=length(Y);
        Fs = 1000;            % Sampling frequency                    
        T = 1/Fs;             % Sampling period       
        t = (0:L-1)*T;        % Time vector


        P2 = abs(Y/L);
        P1 = P2(1:L/2+1);
        P1(2:end-1) = 2*P1(2:end-1);

        f = Fs*(0:(L/2))/L;

        P = polyfit(log(f(end-4900:end)),log(P1(end-4900:end)'),1);
        ind(13,j) = - P(1);
        
        Y=fft(proj2);
        P2 = abs(Y/L);
        P1 = P2(1:L/2+1);
        P1(2:end-1) = 2*P1(2:end-1);
        f = Fs*(0:(L/2))/L;
        P = polyfit(log(f(end-4900:end)),log(P1(end-4900:end)'),1);
        ind(14,j) = - P(1);
    end    
end

