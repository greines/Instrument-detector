function [train_data,train_cat,test_data,test_cat] = ...
    generate_data_ran(max_num,family,frac_train)

mat_file = strcat(family,'_ofps');
load(mat_file);
mat = [];
for i = 1:max_num
    filenum = num2str(i);
    if (length(filenum)<3)
        aux = [];
        for j = 1:3-length(filenum)
            aux = strcat(aux,'0');
        end
        filenum = strcat(aux,filenum);
    end
    filename = strcat('ofp_',family,filenum);
    exi = exist(filename,'var');
    if(~exi)
        continue
    end
    str = strcat('ofp = ',filename,';');
    eval(str);
    aux = reshape(ofp',numel(ofp),1)';
    mat = vertcat(mat,aux);
end

train_data = [];
train_cat = [];
test_data = [];
test_cat = [];

vec_pos = randperm(size(mat,1));

num_train = floor(size(mat,1)*frac_train);
num_test = size(mat,1) - num_train;
pos_train = vec_pos(1:num_train);
pos_test = vec_pos(num_train+1:end);
train_data = vertcat(train_data,mat(pos_train,:));
test_data = vertcat(test_data,mat(pos_test,:));
aux = cell(num_train,1);
for i = 1:num_train
    aux{i} = family;
end
train_cat = vertcat(train_cat,aux);
aux = cell(num_test,1);
for i = 1:num_test
    aux{i} = family;
end
test_cat = vertcat(test_cat,aux);


    
    