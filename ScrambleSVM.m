
model_array = E(:, data.good_channels,1);
res = double(transpose(data.use_scramble));
tmpl={'s','n'};
model_logical=logical(res);
model_response = transpose(tmpl(b+1));
mdl = fitcsvm(model_array(1:180, :),model_response(1:180, :),'KernelFunction','RBF','Standardize',true,'ClassNames',{'s','n'});

total = 180;
success = 0;
for response_el = cell2mat(predict(mdl, model_array(181:end, :)))'

    total = total+1;
      disp('-------')
    disp(response_el)
  
    disp(char(model_response(total)))
      disp('-------')
    if(response_el == char(model_response(total)))
        success = success+1
    else
        disp('noooooo')
    end
    
end

success/(total-180)