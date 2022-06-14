function [B,JLpnm,JDOCpnm,JFpnm,rates]=sweep_gainsandlosses(p, N0, L)
B0 = zeros(length(N0), length(p.m)-2);
JLpnm = zeros(length(N0),3);
JDOCpnm = zeros(length(N0),3);
JFpnm = zeros(length(N0),3);

min_val=1e-5;
B=B0;
m = p.m(3:end);
for i = 1:length(N0)
    ptmp = p;
    ptmp.u0(1) = N0(i);
    sim = simulateChemostat( ptmp, L );
    B(i,:) = mean(sim.B(floor(3*length(sim.t)/4):end,:),1);
    
    JLpnmIntegral = [0 0 0];
    JDOCpnmIntegral = [0 0 0];
    JFpnmIntegral = [0 0 0];
    
    for k = find(sim.t>0.75*sim.t(end),1):length(sim.t)
        
        
        jL = sim.rates.jLreal'; %./m;
        jDOC = sim.rates.jDOC'; %./m;
        jF = sim.rates.jFreal'; %./m;
        jLpnm = calcPicoNanoMicroRate(m, jL);
        jDOCpnm = calcPicoNanoMicroRate(m, jDOC);
        jFpnm = calcPicoNanoMicroRate(m, jF);
        Bpnm = calcPicoNanoMicro(sim.B(k,:), m);
        JLpnmIntegral = JLpnmIntegral + jLpnm.*Bpnm;
        JDOCpnmIntegral = JDOCpnmIntegral + jDOCpnm.*Bpnm;
        JFpnmIntegral = JFpnmIntegral + jFpnm.*Bpnm;
        
    end
    
    JC = sum(JLpnmIntegral + JDOCpnmIntegral + JFpnmIntegral);
    JLpnm(i,:) = 100*JLpnmIntegral/JC;
    JDOCpnm(i,:) = 100*JDOCpnmIntegral/JC;
    JFpnm(i,:) = 100*JFpnmIntegral/JC;
    rates(i)=sim.rates;
    
    
end
% for i=1:length(N0)
%     fprintf(' % 3.1f%% % 3.1f%% % 3.1f%%  |  % 3.1f%% % 3.1f%% % 3.1f%% |  % 3.2f%% % 3.2f%% % 3.2f%%  | %3.1f%%\n', ...
%         [JLpnm(i,1), JDOCpnm(i,1), JFpnm(i,1), ...
%         JLpnm(i,2), JDOCpnm(i,2), JFpnm(i,2), ...
%         JLpnm(i,3), JDOCpnm(i,3), JFpnm(i,3), ...
%         sum(JLpnm(i,:)+JDOCpnm(i,:)+JFpnm(i,:))]);
% end

B(B<min_val)=min_val;

end