
model_array = E(:, data.good_channels)
model_response = double(transpose(data.use_scramble))
mdl = fitcsvm(model_array,model_response,'KernelFunction','linear','Standardize',true,'ClassNames',{'1','0'});

