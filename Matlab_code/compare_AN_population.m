function [mat_GRM,mat_MJN] = compare_AN_population(AN_GRM,AN_MJN,varargin)

num_chann = length(AN_GRM);
num_lev = length(AN_GRM{1});
mat_GRM = zeros(num_lev,num_chann);
mat_MJN = mat_GRM;

for i = 1:num_chann
    for j = 1:num_lev
        mat_GRM(j,i) = length(AN_GRM{i}{j});
    end
end

if (nargin == 2)
    AN_MJNs = AN_MJN.zxstructure;
elseif (nargin == 3)
    AN_MJNs = AN_MJN;
else
    error('Incorrect number of input arguments');
end
for j = 1:num_lev
    for i = 1:num_chann
        if(~isempty(AN_MJNs(j).list))
            mat_MJN(j,i) = length(find(AN_MJNs(j).list(:,1)==i));
        else
            mat_MJN(j,i) = 0;
        end
    end
end

max_norm = max(max(max(mat_MJN)),max(max(mat_GRM)));

mat_MJNn = mat_MJN/max_norm;
mat_GRMn = mat_GRM/max_norm;

diff_mat = abs(mat_MJN - mat_GRM);

clims = [0 max_norm];
subplot(221), imagesc(mat_MJN,clims)
title('MJN AN population')
xlabel('Channel')
ylabel('Sens. level')
colorbar
%colormap gray

subplot(222), imagesc(mat_GRM,clims)
title('GRM AN population')
xlabel('Channel')
ylabel('Sens. level')
colorbar
%colormap gray

subplot(223), imagesc(diff_mat,clims)
title('Absolute difference')
xlabel('Channel')
ylabel('Sens. level')
colorbar
%colormap gray

subplot(224), imagesc(diff_mat,[0 1])
title('Binary difference')
xlabel('Channel')
ylabel('Sens. level')
cmap = [0 0 0.5625;0.5 0 0];
%colormap(cmap)
hold on
L = line(ones(2),ones(2), 'LineWidth',2);
set(L,{'color'},mat2cell(cmap,ones(1,2),3));
legend('Diff == 0','Diff > 0','Location','BestOutside',...
    'Orientation','horizontal')
