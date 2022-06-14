function B=sweep(p, N0, L)
B0 = zeros(length(N0), length(p.m)-2);
min_val=1e-5;
B=B0;
parfor i = 1:length(N0)
    ptmp = p;
    ptmp.u0(1) = N0(i);
    sim = simulateChemostat( ptmp, L );
    B(i,:) = mean(sim.B(floor(3*length(sim.t)/4):end,:),1);
end
B(B<min_val)=min_val;
end