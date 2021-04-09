clear all; close all; clc; % clear workspace
npp = exp(randn(1000)); npp = npp(:); % generate a standard lognormal
% try different examples:

%% 1. constant
aef = .1;
histogram(log(aef.*npp));

%% 2. constant with some additive noise
aef = .4+.1.*randn(length(npp),1); aef(aef<0) = NaN;
histogram(log(aef.*npp));

% nb multiplicative noise would only make things more lognormal
%% 3. proportional
aef = npp./max(npp);
histogram(log(aef.*npp));

%% 4. proportional with some noise
aef = npp./max(npp);
aef = aef + median(aef)./4.*randn(length(npp),1);  aef(aef<0) = NaN;
histogram(log(aef.*npp));

%% 5. scaling to some power
aef = npp.^(1/7); aef = aef./max(aef);
histogram(log(aef.*npp));

%% 6. scaling to some power with some noise
aef = npp.^(1/7); aef = aef./max(aef) + median(aef)./4.*randn(length(npp),1); aef(aef<0) = NaN;
histogram(log(aef.*npp));

%% 7. no relationship with npp: Gaussian
aef = .5 + .125.*randn(length(npp),1); aef(aef<0) = NaN;
histogram(log(aef.*npp));

%% 8. no relationship with npp: triangular
t = makedist('Triangular');
aef = random(t,length(npp),1);
histogram(log(aef.*npp))

%% 9. no relationship with npp: uniform
aef = rand(length(npp),1);
histogram(log(aef.*npp));

%% 10. no relationship with npp: reciprocal

aef = .1./rand(length(npp),1); aef(aef>1) = NaN;
histogram(log(aef.*npp));

%% 11. saturating relationship with npp: error function

aef = erf(npp./10);
histogram(log(aef.*npp));

%% for an example that breaks log-normality -- 12. anti-saturating relationship: error function
% why does this work? it kills the high tail

aef = 1-erf(npp./10);
scatter(npp,aef)
histogram(log(aef.*npp));
axis([prctile(log(aef.*npp),.1), Inf 0 Inf])

%% for another example that breaks log-normality -- 13. step function with some noise
% why does this work? a discontinuity

aef = zeros(size(npp));
aef(npp<median(npp)) = .1;
aef(npp>median(npp)) = .2;
aef(aef==.1) = awgn(aef(aef==.1),25);
aef(aef==.2) = awgn(aef(aef==.2),25);
aef(aef<0) = NaN;
scatter(log(npp),aef,'.')
figure;
histogram(log(aef.*npp));
