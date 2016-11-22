function [ inCirc, ons ] = Nicirc ( E, N, r )

% This function does the following:
% 1. Finds and returns the inner circle's nodes vector 'inCirc'.
% 2. Finds one-sided elements vector 'ons'.

k = 1;
El = E(:, 2:3);
N = N(:, 2:3);
inCirc = 0;
ons = 0;
iSeed = 0.006;
for i = 1 : length(N)
    
    e = El==i;  
    co = sum(e); % count how many times a certain node appears in the elements list
    co2 = sum(co);
    n = co2;
    currN = N(i, :);
    x = currN(1); y = currN(2);
    d = sqrt(x^2 + y^2);
    
    if (n >= 5 && n < 7) && d < r+3*iSeed
        inCirc(k) = i;
        k = k + 1;
    end
    
end

path = 'C:\Users\Naama\Desktop\Research-TAU\csvFiles\';
fileName = 'InnerNodes.csv';
fn = strcat(path, fileName);
csvwrite(fn, inCirc);
path = 'C:\Users\Naama\Desktop\Research-TAU\csvFiles\';
fileName = 'OneSidedElements.csv';
fn = strcat(path, fileName);
csvwrite(fn, inCirc);

end

