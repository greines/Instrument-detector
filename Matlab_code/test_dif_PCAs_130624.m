PCA_elem = [25 30];
num_exec = 5;

results = cell(1,length(PCA_elem));
for i = 1:length(PCA_elem)
    mat_res = zeros(5);
    for j = 1:num_exec
        [~,~,aux] = classif_script(PCA_elem(i));
        mat_res = mat_res+aux;
    end
    mat_res = mat_res/num_exec;
    results{i} = mat_res;
end

figure
clims = [0 1];
for i = 1:length(PCA_elem)
    subplot(1,2,i)
    imagesc(results{i},clims)
    colorbar
    xlabel('True class');
    ylabel('Predicted class');
    str = strcat('Results for numPCA=',num2str(PCA_elem(i)));
    title(str)
end
suptitle('Mean classification results (over 5 exec.) using CART')
