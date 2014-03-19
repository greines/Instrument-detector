function test_sig = testsignal_gen()

prompt = {'Sampling frequency (Hz):','T1 onset (ms):','T1 offset (ms):',...
    'T2 onset (ms):','T2 offset (ms):','T3 onset (ms):',...
    'T3 offset (ms):','Stationary period (ms):','Silence period (ms):'};
dlg_title = 'Test signal parameters setup';
num_lines = 1;
def = {'44100','300','50','40','50','2','40','600','400'};
answer = inputdlg(prompt,dlg_title,num_lines,def);

Fs = str2double(answer{1});
%%%%%% First part
test = linspace(0,1,round(str2double(answer{2})*Fs/1000));
test = [test ones(1,round(str2double(answer{8})*Fs/1000))];
test = [test linspace(1,0,round(str2double(answer{3})*Fs/1000))];
test = [test zeros(1,round(str2double(answer{9})*Fs/1000))];
%%%%%% Second part
test = [test linspace(0,1,round(str2double(answer{4})*Fs/1000))];
test = [test ones(1,round(str2double(answer{8})*Fs/1000))];
test = [test linspace(1,0,round(str2double(answer{5})*Fs/1000))];
test = [test zeros(1,round(str2double(answer{9})*Fs/1000))];
%%%%%% Third part
test = [test linspace(0,1,round(str2double(answer{6})*Fs/1000))];
test = [test ones(1,round(str2double(answer{8})*Fs/1000))];
test = [test linspace(1,0,round(str2double(answer{7})*Fs/1000))];
test = [test zeros(1,round(str2double(answer{9})*Fs/1000))];

gauss_noise = randn(1,length(test));

test_sig = gauss_noise.*test;

