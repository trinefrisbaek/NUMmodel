% This script generates Figure 2 and 3 in Eckford-Soper et al, 2022.
% created by: Trine Frisbæk Hansen, 2022
addpath(genpath(pwd),'-End')
%% setup figure 1 and 2
psize = [18 22];
res = 1200;
fh1=figure('Color','w','Name','Mean sweep plot','units','centimeters','Position',[2 2 psize],'paperunits','centimeters','paperposition',[0 0 psize/res]);
psize = [22 22];
res = 1200; %dpi
fh2=figure('Name','fordeling testcase ','Color','w','units','centimeters','Position',[2 2 psize],'paperunits','centimeters','paperposition',[0 0 psize/res]);

%% Load test info and define results to use
load('testoverview.mat');
load('testtext.mat');
tests_combined=load('testnumbers.mat');
test_names={'test1','test2','test3','test4'};

for testcase=1:4
    clear D_meandataset
    %     clearvars -except testoverview testtext testcase varargin fh1 fh2 fh3
    %% info on current test
    tests=tests_combined.(test_names{testcase});
    %     tests=varargin{testcase};
    testnr=find(strcmp(cellstr(tests{1}),testoverview.(1)));
    testtype=testoverview{testnr,2};
    testdescr=testtext{testtype,2};
    folder=fullfile(pwd, '..','results',['results_testcase',num2str(testtype)]);


    %% Combine dataset
    nRandIter=0;
    for i=1:length(tests)
        load(fullfile(folder,tests{i}));
        nRandIter_start=nRandIter+1;
        nRandIter=nRandIter+modelrun.nRandIter;
        D(nRandIter_start:nRandIter,:,:)=modelrun.D;
    end
    p=modelrun.p;

    %% Choose divisions of plankton into pico, nano and micro
    sections=[2 20 200];
    mass=mass_function(sections./2);


    %% Plot figures
    figure(fh1)
    ax=subplot(4,1,testcase);
    plotfig2(ax,D,p,testcase,testdescr,mass)

    figure(fh2)
    hold on
    plotfig3(D,p,testcase)

end

function plotfig3(D,p,testcase)
x=p.m(3:end);

%% Start loop through nutrient concentrations (start with highest)
for j = length(p.P0):-1:1


    %% pick data from this nutrient concentration
    ii=p.Nbins+j;
    yval=squeeze(D(:,ii,:));
    %
    %
    %%  Find median of MonteCarlo
    y_median=squeeze(median(yval,1,'omitnan'));

    %% bin biomass data
    edges=[0, 0.5:2:100];
    for i=1:25
        thisdata=squeeze(yval(:,i));
        N = histcounts(thisdata,edges);
        mycounts(:,i)=(N./sum(N).*100)';
    end
    mycounts(mycounts<1)=0;
    a=log10(mycounts);
    a(a<0)=0;
    tnr=(testcase-1).*3;

    subplot(4,3,tnr+j)
    [X, Y]=meshgrid(x, edges(1:end-1));
    contourf(X,Y,a,20,'LineStyle','none')

    set(gca,'xscale','log');
    set(gca,'yscale','log');
    ax=gca;
    caxis([log10(0) log10(20)])
    cbarnumbers=1:2:20;
    mylabels = string(1:2:20);
    mylabels(1) = "<1";
    mylabels(end) = ">20";
    colorbar(ax,'YTick',log10(cbarnumbers),'YTickLabel',mylabels);
    hold on;
    plot(x,y_median,'k','LineStyle','-','linewidth',2)
    set(gca,'xscale','log','XTick',10.^(-8:2),'xscale','log')
    xlim([min(x) max(x)])
    ylim([1 100])
    set(gca,'TickDir','in','XColor',[1 1 1],'YColor',[1 1 1])

    ax.YTick=[10^0 10^1 10^2];
    ax.MinorGridAlpha=0.15;

    ax=gca;
    color='{0 0 0}';

    if testcase==4
        change_tickTextColor(ax,color,'x')
    end
    if j==1
        change_tickTextColor(ax,color,'y')
    end

    text(5*10^-9,7*10^1,['P = ',num2str(p.P0(j)./30.97)],'Color','w')

    ax.YLabel.Color='k';
    ax.XLabel.Color='k';

    set(findall(gcf,'-property','FontSize'),'FontSize',10)
    set(findall(gcf,'-property','FontName'),'FontName','Arial')

end

end




