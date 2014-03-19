%family = {'Brass','Reed','StringBowed','StringPlucked','StringStruck'};
family = {'Reed','StringBowed','StringPlucked','StringStruck'};
max_num = 300;
% folder_name = {'01_Brass','02_Reed','03_StringBowed','04_StringPlucked',...
%     '05_StringStruck'};
folder_name = {'02_Reed','03_StringBowed','04_StringPlucked',...
    '05_StringStruck'};

disp('Welcome to the sound onset encoder script')
tic
for i = 1:4
    script_auto_ofps(family{i},max_num,folder_name{i});
end
disp('End of script')
toc