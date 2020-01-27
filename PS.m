function PSind=PS(data)

    Y=fft(data(:,1));
    L=length(Y);
    Fs = 1000;            % Sampling frequency                    
    T = 1/Fs;             % Sampling period       
    t = (0:L-1)*T;        % Time vector


    P2 = abs(Y/L);
    P1 = P2(1:L/2+1);
    P1(2:end-1) = 2*P1(2:end-1);

    f = Fs*(0:(L/2))/L;
    
    P = polyfit(log(f(end-4900:end)),log(P1(end-4900:end)'),1);
    PSind = P(1);    
end