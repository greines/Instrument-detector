function script_auto_ofps(family,max_num,folder_name)

% family = 'Brass';
% max_num = 100;
% folder_name = '01_Brass';

param = parameter_setup();
exi = exist(strcat(family,'_ofps.mat'),'file');
if(exi~=0)
    butt = questdlg('This file already exists. Would you like to overwrite it?',...
        'Existing file','Yes','No','No');
    if(~isequal(butt,'Yes'))
        return
    else
        delete(strcat(family,'_ofps.mat'));
    end
end
str = ['save ',family, '_ofps param'];
eval(str);

for i = 1:max_num
    fprintf('Iteration number %d\n',i);
    filenum = num2str(i);
    if (length(filenum)<3)
        aux = [];
        for j = 1:3-length(filenum)
            aux = strcat(aux,'0');
        end
        filenum = strcat(aux,filenum);
    end
    
    soundpath = strcat('Sons/',folder_name,'/Sound_data/',...
        family,'_',filenum,'.wav');
    input = wavread(soundpath);
    input = input(:,1);
    if (length(input)>300000)
        fprintf('     Iteration %d discarded\n',i);
        continue
    end
    outputname = strcat('ofp_',family,filenum);
    [ofp,~,~] = AN_spike_encoding2(input,param);
    
    str = [outputname, '= ofp;'];
    eval(str);
    
    str = ['save ',family,'_ofps ',outputname,' -append'];
    eval(str);
end
        



