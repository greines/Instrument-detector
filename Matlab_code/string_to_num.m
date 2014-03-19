function numeric_mat = string_to_num(str_mat)

numeric_mat = zeros(1,length(str_mat));
for i = 1:length(numeric_mat)
    if(isequal(str_mat{i},'Brass'))
        numeric_mat(i) = 1;
    elseif(isequal(str_mat{i},'Reed'))
        numeric_mat(i) = 2;
    elseif(isequal(str_mat{i},'StringBowed'))
        numeric_mat(i) = 3;
    elseif(isequal(str_mat{i},'StringPlucked'))
        numeric_mat(i) = 4;
    elseif(isequal(str_mat{i},'StringStruck'))
        numeric_mat(i) = 5;
    end
end