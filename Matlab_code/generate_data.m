function [train_data,train_cat,test_data,test_cat] = ...
    generate_data(family,name,frac_train)

train_data = [];
train_cat = [];
test_data = [];
test_cat = [];

num_train = floor(size(family,1)*frac_train);
num_test = size(family,1) - num_train;
train_data = vertcat(train_data,family(1:num_train,:));
test_data = vertcat(test_data,family(num_train+1:end,:));
aux = cell(num_train,1);
for i = 1:num_train
    aux{i} = name;
end
train_cat = vertcat(train_cat,aux);
aux = cell(num_test,1);
for i = 1:num_test
    aux{i} = name;
end
test_cat = vertcat(test_cat,aux);


    
    