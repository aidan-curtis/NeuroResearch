function [ successRate ] = Onefold( foldNumber, totalFolds )
%ONEFOLD Summary of this function goes here
%   Detailed explanation goes here
    model_array = E(:, data.good_channels);
    res = double(transpose(data.use_scramble));
    tmpl={'s','n'};
    model_logical=logical(res);
    model_response = transpose(tmpl(model_logical+1));
    
    
    fold_start = size(data.use_scramble,2)*(foldNumber-1)/(totalFolds);
    fold_end = size(data.use_scramble,2)*(foldNumber)/(totalFolds);
    
    options = optimset('maxiter',100000);
    mdl = svmtrain(model_array,model_response, 'Kernel_Function','linear', 'SMO_OPTS', options);

    classification = svmclassify(mdl,model_array([1:fold_start+1, fold_end:end], :))
    
    total = fold_start
    success = 0;
    for response_el = cell2mat(classification)'
        disp(response_el)
        total = total+1;
        if(response_el == char(model_response(total)))
            success = success+1;
        end
    end

    success/(fold_end-fold_start)
end

