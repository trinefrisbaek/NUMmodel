for testcase=1:4
    disp(['testcase nr ',num2str(testcase)])
    time = datestr(clock,'YYYY_mm_dd_HH_MM')
    % User defined settings
    % Choose test case 1-4
    % testcase=1
    % Choose number of random iterations:
    nRandIter=1000;
    % Choose number of size classes:
    n = 25;
    % --------------------------- && -----------------------------
    % Choose light level:
    L=300;
    % Choose the mixing rate:
    d = [0.01 0.1];
    % Choose nutrient range and number of bins to iterate over (note ugP/l):
    Nmin=0.01;
    Nmax=40;
    Nbins=10;
    % Choose 3 specific nutrient levels to plot seperate (note molar mass):
    P0 = [0.006 0.06 0.6];
    % --------------------------- && -----------------------------
    % Run in parallel?:
    bParallel='true';
    
    %% Generate Random Parameters
    %-------------------------------------------------------------------------
    % create random initialisation seed and save
    %-------------------------------------------------------------------------
    s=rng('shuffle');% seed random initial random number
    % ------------------------------------------------------------------------
    % Mixing rates: uniform distribution between d:
    % ------------------------------------------------------------------------
    pd_d=makedist('Uniform','lower',d(1),'upper',d(2));
    d_rand=random(pd_d,1,nRandIter);
    % d_rand(:)=d(2);
    % ------------------------------------------------------------------------
    % r*d: Diffusive affility cross-over:
    % ------------------------------------------------------------------------
    % LOGNORMAL DISTRIBUTION:
    meanval=log(0.3);     %=-1.2040
    sigma=log(1.2214); %=0.2
    pd=makedist('lognormal','mu',meanval,'sigma',sigma);
    pd=truncate(pd,exp(meanval-2*sigma),exp(meanval+2*sigma));
    r_star_d=random(pd,1,nRandIter);
    %r_star_d(:)=0.3;
    % ------------------------------------------------------------------------
    % Light harvesting: alphaL and r*L
    % aL = αLr−1(1 − exp(−r/r∗L))(1 − ν)
    % ------------------------------------------------------------------------
    meanval=log(0.25);
    sigma=log(1.6487);
    p_const=0.4;
    pd=makedist('lognormal','mu',meanval,'sigma',sigma);
    pd=truncate(pd,exp(meanval-2*sigma),exp(meanval+2*sigma));
    rand_y=random(pd,1,nRandIter);
    %rand_y(:)=y;
    alpha_l=(3.*rand_y)./(4*p_const);
    
    
    meanval=log(7.5); %
    sigma=log(1.6487);
    pd=makedist('lognormal','mu',meanval,'sigma',sigma);
    pd=truncate(pd,exp(meanval-2*sigma),exp(meanval+2*sigma));
    rand_rlstar=random(pd,1,nRandIter);
    %rand_rlstar(:)=rLstar;
    % ------------------------------------------------------------------------
    % phagotrophic clearance rate: aF
    % ------------------------------------------------------------------------
    meanval=log(0.0189);
    sigma=log(4.8576);
    pd=makedist('lognormal','mu',meanval,'sigma',sigma);
    pd=truncate(pd,exp(meanval-2*sigma),exp(meanval+2*sigma));
    aF_random=random(pd,1,nRandIter);
    %aF_random(:)=0.03;
    % ------------------------------------------------------------------------
    % passive losses: cpassive
    % ------------------------------------------------------------------------
    meanval=log(0.03);
    sigma=log(1.8221);
    pd=makedist('lognormal','mu',meanval,'sigma',sigma);
    pd=truncate(pd,exp(meanval-2*sigma),exp(meanval+2*sigma));
    c_passive_random=random(pd,1,nRandIter);
    %c_passive_random(:)=c_passive;
    % ------------------------------------------------------------------------
    % maximum synthesis rate: αMax
    % ------------------------------------------------------------------------
    meanval=log(0.4883);
    sigma=log(2.1029);
    pd=makedist('lognormal','mu',meanval,'sigma',sigma);
    pd=truncate(pd,exp(meanval-2*sigma),exp(meanval+2*sigma));
    alphaMax_rand=random(pd,1,nRandIter);
    %alphaMax_rand(:)=alphaMax;
    % ------------------------------------------------------------------------
    % basal metabolism coef: αR
    % ------------------------------------------------------------------------
    meanval=log(0.1);
    sigma=log(1.4918);
    pd=makedist('lognormal','mu',meanval,'sigma',sigma);
    pd=truncate(pd,exp(meanval-2*sigma),exp(meanval+2*sigma));
    alphaR_rand=random(pd,1,nRandIter);
    %alphaR_rand(:)=alphaR;
    % ------------------------------------------------------------------------
    % assemble random parameter
    % ------------------------------------------------------------------------
    randParam=[r_star_d,alpha_l,rand_rlstar,aF_random,c_passive_random,alphaMax_rand,alphaR_rand];
    
    %% Load parameters to Fortran
    nRandPar=length(randParam)/nRandIter;
    loadparameters(nRandIter,nRandPar,randParam,bParallel)
    %% Generate nutrient vector
    N0 = logspace(log10(Nmin),log10(Nmax),Nbins); % nutrient array
    uM_to_ug = 30.97; % conversion from Molar to ugP/l.
    P0 = P0.*uM_to_ug; %Three selected deep nutrient levels
    
    nut=[N0,P0];
    %% Setup iteration loop
    D=zeros(nRandIter,length(nut),n);
    tic
    for iRand=1:nRandIter
        %----------------------------------------------------------------------
        % Choose the correct input file
        %----------------------------------------------------------------------
        switch testcase
            case 1
                copyfile '../input/input_testcase1.nlm' '../input/input.nlm'
                outdir= fullfile(pwd, '..','results','results_testcase1');
            case 2
                copyfile '../input/input_testcase2.nlm' '../input/input.nlm'
                outdir= fullfile(pwd, '..','results','results_testcase2');
            case 3
                copyfile '../input/input_testcase3.nlm' '../input/input.nlm'
                outdir= fullfile(pwd, '..','results','results_testcase3');
            case 4
                copyfile '../input/input_testcase4.nlm' '../input/input.nlm'
                outdir= fullfile(pwd, '..','results','results_testcase4');
        end
        %----------------------------------------------------------------------
        % save parameters to p
        %----------------------------------------------------------------------
        p = setupGeneralists_random(n,bParallel, iRand);
        p.tEnd = 1000;
        p.u0(3:end) = 0.0001; % for faster convergence
        p.iRand=iRand;
        p.d=d_rand(iRand);
        p.nameModel = 'chemostat';
        p.tSave = 1;
        p.depthProductiveLayer = 50; % (meters) Only needed for calculation of functions
        p.P0=P0;
        p.N0=N0;
        p.Nbins=Nbins;
        
        %----------------------------------------------------------------------
        % run simulation
        %----------------------------------------------------------------------
        D(iRand,:,:)=sweep(p,nut,L);
    end
    %% Save output
    toc
    modelrun.p=p;
    modelrun.s=s;
    modelrun.d=d;
    modelrun.nRandIter=nRandIter;
    modelrun.rand_Param=randParam;
    modelrun.D=D;
    modelrun.d=d_rand;
    save(fullfile(outdir,[time,'.mat']),'modelrun')
    disp('done')
end
