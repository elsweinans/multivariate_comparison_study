% Function that sorts the values in a list. If a value appears twice
% it receives the same number. if high == 1 high values are better,
% otherwise low values are better.

function performance = eval_values(bars,high)
 
    values = unique(bars)
    performance = zeros(12,1)
    for i = 1:length(values)
        if high == 1
            idx = find(bars==values(end - (i-1)))
        else
            idx = find(bars==values(i))
        end
        performance(idx) = i        
    end
end