%% Downsample the existing data
clearvars down_trial X
count = 0
for channel = [1:20]
    count = count+1
    for trial = [1:20]
        down_trial(count, :, trial) = downsample(trial_data(channel, :, trial), 5);
    end
end
X = down_trial;
    

%% Parameters

ntrials   = 20;     % number of trials
nobs      = 1000;   % number of observations per trial

regmode   = 'OLS';  % VAR model estimation regression mode ('OLS', 'LWR' or empty for default)
icregmode = 'LWR';  % info 
morder    = 'BIC';  % model order to use ('actual', 'AIC', 'BIC' or supplied numerical value)
momax     = 20;     % maximum model order for model order estimation

acmaxlags = '';   % maximum autocovariance lags (empty for automatic calculation)

tstat     = '';     % statistical test for MVGC:  'F' for Granger's F-test (default) or 'chi2' for Geweke's chi2 test
alpha     = 0.05;   % significance level for significance test
mhtc      = 'FDR';  % multiple hypothesis test correction (see routine 'significance')

fs        = 200;    % sample rate (Hz)
fres      = [];      % frequency resolution (empty for automatic calculation)

seed      = 0;      % random seed (0 for unseeded)

%% Model order estimation (<mvgc_schema.html#3 |A2|>)

% Calculate information criteria up to specified maximum model order.

ptic('\n*** tsdata_to_infocrit\n');
[AIC,BIC,moAIC,moBIC] = tsdata_to_infocrit(X,momax,icregmode);
ptoc('*** tsdata_to_infocrit took ');

% Plot information criteria.

figure(1); clf;
plot_tsdata([BIC, BIC]',{'AIC','BIC'},1/fs);
title('Model order estimation');

% amo = size(AT,3); % actual model order

fprintf('\nbest model order (AIC) = %d\n',moAIC);
fprintf('best model order (BIC) = %d\n',moBIC);
% fprintf('actual model order     = %d\n',amo);

% Select model order.


if strcmpi(morder,'AIC')
    morder = moAIC;
    fprintf('\nusing AIC best model order = %d\n',morder);
elseif strcmpi(morder,'BIC')
    morder = moBIC;
    fprintf('\nusing BIC best model order = %d\n',morder);
else
    fprintf('\nusing specified model order = %d\n',morder);
end

morder = 3

%% VAR model estimation (<mvgc_schema.html#3 |A2|>)

% Estimate VAR model of selected order from data.

ptic('\n*** tsdata_to_var... ');
[A,SIG] = tsdata_to_var(X,morder,regmode);
ptoc;

% Check for failed regression

assert(~isbad(A),'VAR estimation failed');

% NOTE: at this point we have a model and are finished with the data! - all
% subsequent calculations work from the estimated VAR parameters A and SIG.

%% Autocovariance calculation (<mvgc_schema.html#3 |A5|>)

% The autocovariance sequence drives many Granger causality calculations (see
% next section). Now we calculate the autocovariance sequence G according to the
% VAR model, to as many lags as it takes to decay to below the numerical
% tolerance level, or to acmaxlags lags if specified (i.e. non-empty).

ptic('*** var_to_autocov... ');
[G,info] = var_to_autocov(A,SIG,acmaxlags);
ptoc;

% The above routine does a LOT of error checking and issues useful diagnostics.
% If there are problems with your data (e.g. non-stationarity, colinearity,
% etc.) there's a good chance it'll show up at this point - and the diagnostics
% may supply useful information as to what went wrong. It is thus essential to
% report and check for errors here.

var_info(info,true); % report results (and bail out on error)

%% Granger causality calculation: time domain  (<mvgc_schema.html#3 |A13|>)

% Calculate time-domain pairwise-conditional causalities - this just requires
% the autocovariance sequence.

ptic('*** autocov_to_pwcgc... ');
F = autocov_to_pwcgc(G);
ptoc;

% Check for failed GC calculation

assert(~isbad(F,false),'GC calculation failed');

% Significance test using theoretical null distribution, adjusting for multiple
% hypotheses.

pval = mvgc_pval(F,morder,nobs,ntrials,1,1,nvars-2,tstat); % take careful note of arguments!
sig  = significance(pval,alpha,mhtc);

% Plot time-domain causal graph, p-values and significance.

figure(2); clf;
subplot(1,3,1);
plot_pw(F);
title('Pairwise-conditional GC');
subplot(1,3,2);
plot_pw(pval);
title('p-values');
subplot(1,3,3);
plot_pw(sig);
title(['Significant at p = ' num2str(alpha)])

% For good measure we calculate Seth's causal density (cd) measure - the mean
% pairwise-conditional causality. We don't have a theoretical sampling
% distribution for this.

cd = mean(F(~isnan(F)));

fprintf('\ncausal density = %f\n',cd);

%% Granger causality calculation: frequency domain  (<mvgc_schema.html#3 |A14|>)
% Do not use until you know what it means

% Calculate spectral pairwise-conditional causalities at given frequency
% resolution - again, this only requires the autocovariance sequence.

ptic('\n*** autocov_to_spwcgc... ');
f = autocov_to_spwcgc(G,fres);
ptoc;

% Check for failed spectral GC calculation

assert(~isbad(f,false),'spectral GC calculation failed');

% Plot spectral causal graph.

figure(3); clf;
plot_spw(f,fs);

%% Granger causality calculation: frequency domain -> time-domain  (<mvgc_schema.html#3 |A15|>)

% Check that spectral causalities average (integrate) to time-domain
% causalities, as they should according to theory.

fprintf('\nchecking that frequency-domain GC integrates to time-domain GC... \n');
Fint = smvgc_to_mvgc(f); % integrate spectral MVGCs
mad = maxabs(F-Fint);
madthreshold = 1e-5;
if mad < madthreshold
    fprintf('maximum absolute difference OK: = %.2e (< %.2e)\n',mad,madthreshold);
else
    fprintf(2,'WARNING: high maximum absolute difference = %e.2 (> %.2e)\n',mad,madthreshold);
end

%%
% <mvgc_demo.html back to top>
