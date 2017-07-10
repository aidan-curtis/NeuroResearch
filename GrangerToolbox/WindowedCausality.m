
%% Downsample the existing data
countnum = 0
window_start = 500
% for window_start = [1:250:5000]
    countnum = countnum+1
    clearvars down_trial X
    window_end = window_start+999

    important = [1:37]  
    count = 0

    for channel = important
        count = count+1
        for trial = data.use_trials(1:20)
            down_trial(count, :, trial) = downsample(trial_data(channel, window_start:window_end, trial), 20);
        end
    end
    
    X = down_trial;
    nvars = size(X, 1)

    ntrials   = 20;     % number of trials
    nobs      = 25;   % number of observations per trial

    regmode   = 'OLS';  % VAR model estimation regression mode ('OLS', 'LWR' or empty for default)
    icregmode = 'LWR';  % info 
    morder    = 'BIC';  % model order to use ('actual', 'AIC', 'BIC' or supplied numerical value)
    momax     = 20;     % maximum model order for model order estimation

    acmaxlags = '';   % maximum autocovariance lags (empty for automatic calculation)

    tstat     = '';     % statistical test for MVGC:  'F' for Granger's F-test (default) or 'chi2' for Geweke's chi2 test
    alpha     = 0.05;   % significance level for significance test
    mhtc      = 'FDR';  % multiple hypothesis test correction (see routine 'significance')

    fs        = 50;    % sample rate (Hz)
    fres      = [];      % frequency resolution (empty for automatic calculation)

    seed      = 0;      % random seed (0 for unseeded)

    % Calculate information criteria up to specified maximum model order.

    ptic('\n*** tsdata_to_infocrit\n');
    [AIC,BIC,moAIC,moBIC] = tsdata_to_infocrit(X,momax,icregmode);
    ptoc('*** tsdata_to_infocrit took ');

    % Plot information criteria.

    figure(1); clf;
    plot_tsdata([AIC, BIC]',{'AIC','BIC'},1/fs);
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


    ptic('\n*** tsdata_to_var... ');
    [A,SIG] = tsdata_to_var(X,morder,regmode);
    ptoc;

    % Check for failed regression

    assert(~isbad(A),'VAR estimation failed');

    % NOTE: at this point we have a model and are finished with the data! - all
    % subsequent calculations work from the estimated VAR parameters A and SIG.


    ptic('*** var_to_autocov... ');
    [G,info] = var_to_autocov(A,SIG,acmaxlags);
    ptoc;



    var_info(info,true); % report results (and bail out on error)

    ptic('*** autocov_to_pwcgc... ');
    F(countnum, :, :) = autocov_to_pwcgc(G);
    ptoc;

% end