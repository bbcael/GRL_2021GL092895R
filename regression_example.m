clear all; close all; clc; 
load xc % load F_IC data
load xs % load F_Si data
load y % load F_OC data
load z % load depth data

yl = log(y);

b = .5:.01:1.5; % b-values to try
csr = .5:.01:2; % IC-Si ratios to try

for k = 1:1000; % bootstrap

btstrp = 1:randi(2798,2798,1);
yb = yl(btstrp);
xcb = xc(btstrp);
xsb = xs(btstrp);
zb = z(btstrp);

for i = 1:length(b); % scan parameter space of b & ratio for each iteration
    for j = 1:length(csr);
        y = yb+b(i).*(log(zb)-log(3500));
        x = log(xcb+csr(j).*xsb);
        [m(i,j),a(i,j),r(i,j),sm(i,j),sb(i,j)] = lsqfitma(x,y); % major axis model-ii regression
        B(i,j) = b(i);
        CSR(i,j) = csr(j);
    end
end

[R(k),indx] = max(r(:));
bb(k) = B(indx);
csrb(k) = CSR(indx);
k
end