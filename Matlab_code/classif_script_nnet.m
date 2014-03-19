%classification script
function [net,means_vec,class_result] = classif_script_nnet(numel_PCA)

family = {'Brass','Reed','StringBowed','StringPlucked','StringStruck'};
%family = {'Reed','StringPlucked','StringStruck'};
max_num = 300;
%numel_PCA = 50;

%%%% Output variables are empty (only for compatibility)
means_vec = [];

%%%% Neural Network params: %%%%
hidden_nodes = [numel_PCA];
frac_train = 0.70;
frac_test = 0.2;
frac_val = 0.1;
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
train_data = [];
train_cat = [];
train_target = [];
test_data = [];
test_cat = [];
test_target = [];
for i = 1:length(family)    
    [aux_trd,aux_trc,aux_ted,aux_tec] = ...
    generate_data_ran(max_num,family{i},frac_train);
    
    train_data = vertcat(train_data,aux_trd);
    train_cat = vertcat(train_cat,aux_trc);
    targ_aux_tr = zeros(length(aux_trc),5);
    targ_aux_tr(:,i) = 1;
    train_target = vertcat(train_target,targ_aux_tr);
    test_data = vertcat(test_data,aux_ted);
    test_cat = vertcat(test_cat,aux_tec);
    targ_aux_te = zeros(length(aux_tec),5);
    targ_aux_te(:,i) = 1;
    test_target = vertcat(test_target,targ_aux_te);
end

total_data = vertcat(train_data,test_data);
total_cat = vertcat(train_cat,test_cat);
total_target = vertcat(train_target,test_target);

[~,total_data_PCA] = princomp(total_data);
total_data_PCA_clip = total_data_PCA(:,1:numel_PCA);

inputs = total_data_PCA_clip';
targets = total_target';

% Create a Pattern Recognition Network
hiddenLayerSize = hidden_nodes;
net = patternnet(hiddenLayerSize);


% Setup Division of Data for Training, Validation, Testing
net.divideParam.trainRatio = frac_train;
net.divideParam.valRatio = frac_val;
net.divideParam.testRatio = frac_test;


% Train the Network
[net,tr] = train(net,inputs,targets);

% Test the Network
outputs = net(inputs);
%errors = gsubtract(targets,outputs);
%performance = perform(net,targets,outputs);

% View the Network
%view(net)

% Plots
% Uncomment these lines to enable various plots.
% figure, plotperform(tr)
% figure, plottrainstate(tr)
figure, plotconfusion(targets,outputs)
%figure, ploterrhist(errors)

% class_result = cell(size(outputs,2),1);
% for i = 1:size(outputs,2)
%     if(outputs(1,i)==1)
%         class_result{i} = family{1};
%     elseif(outputs(2,i)==1)
%         class_result{i} = family{2};
%     elseif(outputs(3,i)==1)
%         class_result{i} = family{3};
%     elseif(outputs(4,i)==1)
%         class_result{i} = family{4};
%     elseif(outputs(5,i)==1)
%         class_result{i} = family{5};
%     end
% end
% [~,class_result] = find(outputs);
class_result = 0;
        

