


model_array = E(:, data.good_channels);
res = double(transpose(data.use_scramble));
tmpl={'s','n'};
model_logical=logical(res);
model_response = transpose(tmpl(model_logical+1));


options = optimset('maxiter',100000);
mdl = svmtrain(model_array(1:200,:),model_response(1:200), 'Kernel_Function','linear', 'SMO_OPTS', options, 'showplot', true);

classification = svmclassify(mdl,model_array(201:end, :), 'showplot', false)

total = 200
success = 0;
for response_el = cell2mat(classification)'
    disp(response_el)
    total = total+1;
    if(response_el == char(model_response(total)'))
        success = success+1;
    end
end

success/(total-201)