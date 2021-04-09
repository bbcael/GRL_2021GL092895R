clear all; close all; clc;
load x % load data
% log-transform x if x is not already
 
mu_min = 1; % set parameter ranges+resolution, below are examples
mu_max = 2;
mu_res = 0.01;
sig_min = .5;
sig_max = 1.5;
sig_res = 0.01;
mu = mu_min:mu_res:mu_max; 
sig = sig_min:sig_res:sig_max;
mu = repmat(mu,length(sig),1);
sig = repmat(sig,size(mu,2),1)';

[ycdf,xcdf] = ecdf(x);  
ycdf = ycdf(2:end); xcdf = xcdf(2:end); % remove extra endpoints ecdf adds
for i = 1:size(mu,1); % scan parameter space
    for j = 1:size(mu,2);
        p = normcdf(xcdf,mu(i,j),sig(i,j));
        dy = ycdf-p;
        d(i,j) = max(abs(dy)); % Kolmogorov-Smirnov
        v(i,j) = max(abs(dy))+max(abs(-dy)); % Kuiper
        a(i,j) = max(abs(dy)./sqrt(p.*(1-p))); % Anderson-Darling
    end
end
clear i j;

[A,aind] = min(a(:)); % best fits for each statistic
[D,dind] = min(d(:));
[V,vind] = min(v(:));
ams = [mu(aind),sig(aind)]; % associated parameters
dms = [mu(dind),sig(dind)];
vms = [mu(vind),sig(vind)];

clear vind v sig_res sig_min sig_max sig p mu_res mu_min mu_max mu dy dind d aind a;