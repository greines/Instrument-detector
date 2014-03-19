function target = str_to_target(results)

target = zeros(5,length(results));

for i = 1:length(results)
    if(isequal(results{i},'Brass'))
        target(1,i) = 1;
    elseif(isequal(results{i},'Reed'))
        target(2,i) = 1;
    elseif(isequal(results{i},'StringBowed'))
        target(3,i) = 1;
    elseif(isequal(results{i},'StringPlucked'))
        target(4,i) = 1;
    elseif(isequal(results{i},'StringStruck'))
        target(5,i) = 1;
    end
end