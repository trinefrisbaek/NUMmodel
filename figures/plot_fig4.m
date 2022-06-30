% This script generates Figure 4 in Eckford-Soper et al, 2022. 
% created by: Ken H. Andersen and Trine Frisbæk Hansen, 2022

%% setup figure
psize = [10 22];
res = 1200; %dpi
fh1=figure('Color','w','Name','Gains and losses','units','centimeters','Position',[2 2 psize],'paperunits','centimeters','paperposition',[0 0 psize/res]);

%% Load data
for testcase=1:4
    subplot(4,1,testcase)
    switch testcase
        case 1
            load('../results/results_testcase1/2022_06_06_15_54.mat');
        case 2
            load('../results/results_testcase2/2022_06_06_23_35.mat');
        case 3
            load('../results/results_testcase3/2022_06_07_06_49.mat');
        case 4
            load('../results/results_testcase4/2022_06_07_10_05.mat');
    end

    jF=zeros(modelrun.nRandIter,3,25);
    jN=zeros(modelrun.nRandIter,3,25);
    jLreal=zeros(modelrun.nRandIter,3,25);
    jDOC=zeros(modelrun.nRandIter,3,25);
    jMax=zeros(modelrun.nRandIter,3,25);
    jTot=zeros(modelrun.nRandIter,3,25);
    mortpred=zeros(modelrun.nRandIter,3,25);
    jR=zeros(modelrun.nRandIter,3,25);
    mort2=zeros(modelrun.nRandIter,3,25);
    for i=1:modelrun.nRandIter %nr iterations
        for j=1:size(modelrun.rates,2) %nr nutrients
            jF(i,j,:)=modelrun.rates(i, j).jF;
            jN(i,j,:)=modelrun.rates(i, j).jN;
            jLreal(i,j,:)=modelrun.rates(i, j).jLreal;
            jDOC(i,j,:)=modelrun.rates(i, j).jDOC;
            jMax(i,j,:)=modelrun.rates(i, j).jMax;
            jTot(i,j,:)=modelrun.rates(i, j).jTot;
            mortpred(i,j,:)=modelrun.rates(i, j).mortpred;
            jR(i,j,:)=modelrun.rates(i, j).jR;
            mort2(i,j,:)=modelrun.rates(i, j).mort2;
        end
    end

    %% calculate median
    jF=squeeze(median(jF,1));
    jN=squeeze(median(jN,1));
    jLreal=squeeze(median(jLreal,1));
    jDOC=squeeze(median(jDOC,1));
    jMax=squeeze(median(jMax,1));
    jTot=squeeze(median(jTot,1));
    mortpred=squeeze(median(mortpred,1));
    jR=squeeze(median(jR,1));
    mort2=squeeze(median(mort2,1));

    m = modelrun.p.m(3:end);

    %% Plot result

    for jj=3
        hold on
        semilogx(m, jTot(jj,:),'LineStyle','-','color','k','linewidth',2) %rød

        semilogx(m, jLreal(jj,:)','LineStyle','-','Color',[0.59 0.69 0.46],'linewidth',2,'marker','none') %gul

        semilogx(m, jF(jj,:)','LineStyle','-','Color',[0.62 0.08 0.18],'linewidth',2,'marker','none') %rød

        semilogx(m, jDOC(jj,:)','LineStyle','-','color',[0.30 0.75 0.93],'linewidth',2,'marker','none') %blå

        semilogx(m, -mortpred(jj,:)','LineStyle','-','color',[0.8 0.8 0.8],'linewidth',2) %grå

        semilogx(m, -mort2(jj,:)','LineStyle','-','color',[0.65 0.65 0.65],'linewidth',2) %grå

        set(gca,'XScale','log')
        xlim([log(min(m)) log(10^1)])
        ylim([-0.2 0.9])
        ax=gca;
        ax.TickDir='out';
        ax.XTick=[10^-8 10^-6 10^-4 10^-2 10^0];
        box on

    end

    sections=[2 20 200];
    mass=mass_function(sections./2);
    for ii=1:3
        plot([mass(ii) mass(ii)],[-0.2 0.9],':k');
    end
    title(['case',string(testtext{testcase,2})])

end

set(findall(gcf,'-property','FontSize'),'FontSize',10)
set(findall(gcf,'-property','FontName'),'FontName','Arial')

