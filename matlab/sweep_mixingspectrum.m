function [prodGross]=sweep_mixingspectrum(p, N0, L, bUnicellularloss)
M = 50; % depth of productive zone
epsilonL=0.8;

for i = 1:length(N0)
    ptmp = p;
    ptmp.u0(1) = N0(i);
    losses=isequal(bUnicellularloss,'true');
    
    sim = simulateChemostat( ptmp, L, losses);
    
    prodGross(i) = 0;
    ixStart = find(sim.t>(sim.t(end)/2),1);
    dt = gradient(sim.t);
    for j = ixStart:length(sim.t)
        jL = sim.rates.jLreal'; %./m;
        
        prodGross(i) = prodGross(i) + ...
            M*365*1e-3 * sum(jL.*sim.B(j,:))./epsilonL .* dt(j);
       
    end

end
deltaT = ptmp.tEnd/2;
prodGross = prodGross./deltaT;

end