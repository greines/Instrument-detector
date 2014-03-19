function leak = compute_leak(i,param)

cf = param.cf(i);

if (cf<=500)
    leak = 1/(0.15*500);
elseif (cf>=3500)
    leak = 1/(0.15*3500);
else
    leak = 1/(0.15*cf);
end