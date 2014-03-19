%classification script
function [t,means_vec,class_result] = classif_script(numel_PCA)

family = {'Brass','Reed','StringBowed','StringPlucked','StringStruck'};
%family = {'Reed','StringPlucked','StringStruck'};
max_num = 300;
%numel_PCA = 50;
frac_train = 0.70;
train_data = [];
train_cat = [];
test_data = [];
test_cat = [];

for i = 1:length(family)    
    [aux_trd,aux_trc,aux_ted,aux_tec] = ...
    generate_data_ran(max_num,family{i},frac_train);
    
    train_data = vertcat(train_data,aux_trd);
    train_cat = vertcat(train_cat,aux_trc);
    test_data = vertcat(test_data,aux_ted);
    test_cat = vertcat(test_cat,aux_tec);
end
prior_prob = [0.212 0.273 0.243 0.139 0.133];
means_vec = sum(train_data)/size(train_data,2);

% perform PCA and build classif. tree with training data
[coeff_PCA,train_dataPCA] = princomp(train_data);

%%%%%%%%% CHOOSE AN OPTION: FOR CART UNCOMMENT classregtree LINE
%%%%%%%%%                   FOR QDA COMMENT IT
t = classregtree(train_dataPCA(:,1:numel_PCA),train_cat,'priorprob','empirical');


% for test data, subtract column means and project into the new subspace
test_data_submean = zeros(size(test_data));
for i = 1:size(test_data,2)
    test_data_submean(:,i) = test_data(:,i) - means_vec(i);
end
test_dataPCA = test_data_submean*coeff_PCA;

%%%%%%%%% CHOOSE AN OPTION: FOR CART UNCOMMENT eval LINE AND COMMENT THE
%%%%%%%%% FOLLOWING TWO (t AND classify)
%%%%%%%%%                   FOR QDA JUST DO THE OPPOSITE
results = eval(t,test_dataPCA(:,1:numel_PCA));
%  t=1;
%  results = classify(test_dataPCA(:,1:numel_PCA),train_dataPCA(:,1:numel_PCA),train_cat,'quadratic',prior_prob);

%%%%%%%%%% MATLAB confusion matrix %%%%%%%%%%%%%%%%%%
outputs = str_to_target(results);
targets = str_to_target(test_cat);

figure, plotconfusion(targets,outputs)
class_result = 0;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%% Self-implemented confusion matrix %%%%%%%%
% results_num = string_to_num(results);
% test_cat_num = string_to_num(test_cat);
% 
% class_result = zeros(5);
% for i = 1:length(results_num)
%     class_result(results_num(i),test_cat_num(i)) = ...
%         class_result(results_num(i),test_cat_num(i))+1;
% end
% 
% for i = 1:5
%     sum_row = sum(class_result(i,:));
%     class_result(i,:) = class_result(i,:)./sum_row;
% end
% imagesc(class_result)
% colorbar
% xlabel('True class');
% ylabel('Predicted class');

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%