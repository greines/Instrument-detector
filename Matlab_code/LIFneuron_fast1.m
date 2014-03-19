function onset_cell = LIFneuron_fast1(C,param)

tic
I = zeros(size(C));
for i = 1:param.n_channels
    cnt = 0;
    for j = i-param.adj_ch:1:i+param.adj_ch
        if(j<=0 || j>param.n_channels)
            continue
        else
            I(:,i,:) = I(:,i,:) + C(:,j,:);
            cnt = cnt+1;
        end
    end
    multiplier = param.w/cnt;
    I(:,i,:) = I(:,i,:)*multiplier;
end

% ODE solver (Euler approx.)
leak = zeros(param.num_levels,param.n_channels);
for i = 1:param.n_channels
    leak(:,i) = compute_leak(i,param);
end
dt = 1/param.Fs;
I(:,:,1) = 0; %I will be substituted by the values of V
for i = 2:size(C,3)
    current_I = I(:,:,i); %current value of I
    % Beyond this point (for the sake of memory saving) I matrix is
    % overwritten by the values of V
    I(:,:,i) = I(:,:,i-1) + dt*(-I(:,:,i-1)./leak + current_I);
end
onset_cell = cell(length(param.cf),1);
for i = 1:param.n_channels
    aux = cell(1,param.num_levels);
    for j = 1:param.num_levels
        sp = find(I(j,i,:)>=param.threshold,1,'first');
        onset = [];
        while (~isempty(sp))
            I(j,i,sp:end) = I(j,i,sp:end)-I(j,i,sp);
            refr_samp = round(param.Fs*param.refrac_time);
            I(j,i,sp:min(size(I,3),sp+refr_samp)) = 0;
            I(j,i,sp+refr_samp+1:end) = I(j,i,sp+refr_samp+1:end)...
                -I(j,i,min(size(I,3),sp+refr_samp+1));
            onset = [onset sp];
            sp = find(I(j,i,:)>=param.threshold,1,'first');
        end
        aux{j} = onset;
    end
    onset_cell{i} = aux;
end
toc