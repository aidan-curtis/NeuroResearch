train_array = [1, 2;2, 3;2, 2; 2, 2.5; -1,-2;-1, -3; -2, -1; 3,3];
train_response = ['r';'r';'r';'r';'b';'b';'b'; 'b'];
mdl = fitcsvm(train_array,train_response,'KernelFunction','linear','Standardize',false);

for rand = [1:2000]
    x(rand) = normrnd(0,15);
end
for rand = [1:2000]
    y(rand) = normrnd(0,15);
end
test = [x' y'];

pred = predict(mdl,test);
for a = [1: size(pred,1)]
    pred(a)
    if pred(a) == 'r'
        colors(a) = 1;
    else
        colors(a) = 0;
    end
end
colors
scatter(x,y, 10,colors );
