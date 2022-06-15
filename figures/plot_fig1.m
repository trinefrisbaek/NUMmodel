% This script generates the first figure in Eckford-Soper 2022 displaying
% acritarch data from the Paleoproterozoic, Mesoproterozoic and
% Neoproterozoic.
% Data from J. W. Huntley, S. Xiao, M. Kowalewski, 1.3 Billion years of 
% acritarch history: An empirical morphospace approach. Precambrian 
% Research 144, 52–68 (2006)

% created by: Trine Frisbæk Hansen, 2022

addpath(genpath(pwd),'-End')

%% Setup figure
psize = [18 10];
res = 1200;
fh1=figure('Color','w','Name','fossil data','units','centimeters','Position',[2 2 psize],'paperunits','centimeters','paperposition',[0 0 psize/res]);
t = tiledlayout(3,1,'TileSpacing','Compact');
edges = 10.^(-9:0.1:1);% create logarithmic bin sizes
titles={'Neoproterozoic','Mesoproterozoic','Paleoproterozoic'};
%% Load dataset
acritarch_data=load('acritarchs_dimensions.mat');
era={'neo','meso','paleo'};

%% Define size class ranges for pico-, Nano- and Microplankton
sections=[2 20 200];
sections_mass=mass_function(sections./2);

for ii=1:3
    nexttile
    dataset=acritarch_data.(era{ii});
    %% Find specimen with only one reported dimension: assume spherical
    % this means that the same length will be used in both directions
    [i,j]=find(isnan(dataset));
    for x=1:length(i)
        dataset(i(x),:)=dataset(i(x),j(x)==[2 1]);
    end
    %% For specimen with different min and max: determine ESR
    %we assume the missing ellipsoide length equals min
    % Ellipsoide:   V=4/3*pi*A*B*C =>  Sphere:  V=4/3*pi*r^3
    % r=(A*B*C)^(1/3)
    ESR=(dataset(:,2).*2.*dataset(:,1)).^(1/3);
    %% For specimen min==max we assume the given dimension to be diameter
    ESR(i)=dataset(i,1)/2;
    %% ESR --> mass
    data_mass=mass_function(ESR);
    
    %% Plot histogram
    data_mass(data_mass>10)=10;
    h=histogram(data_mass,edges,'EdgeColor','w','FaceColor',[0.65 0.65 0.65]);
    set(gca,'XScale','log','TickLength',[0.005, 0.005])
    hold on
    [pHat,~]= lognfit(data_mass);
    y=2*(log(10^0.05)*length(data_mass)).*normpdf(log(edges),pHat(1),pHat(2));
    plot(edges,y,'Color',[71 65 154]./255);
    ax=gca;
    if eq(ii,3)
        set(ax,'XTick',[0.00000001,0.000001,0.0001,0.01,1,10],'XTickLabel',{'10^{-8}','10^{-6}','10^{-4}','10^{-2}','10^{0}','>10^{1}'});
        
    else
        set(ax,'XTickLabel',[]);
    end
    if eq(ii,1)
        ylim([0 40])
    else
        ylim([0 10])
    end
    
    xlim([3.1623e-09   10.1000])
    %% Plot size class divisions, titles and legend
    for x=1:3
        plot([sections_mass(x) sections_mass(x)],[min(ax.YLim) max(ax.YLim)],'k','LineWidth',0.5,'LineStyle',':')
    end
    text(5*10^-9, ax.YLim(2)*0.8,titles{ii},'FontAngle','italic')
    
    if eq(ii,3)
        legend('','lognormal distribution')
    end
    
    ax.YGrid = 'on';
    ax.YMinorGrid = 'on';
    ax.XGrid = 'on';
    ax.XMinorGrid = 'on';
    ax.MinorGridAlpha=0.15;

end
xlabel(t,'Cell mass (\mugC)')
ylabel(t,'Number of specimens in size bins')
set(findall(gcf,'-property','FontSize'),'FontSize',10)
set(findall(gcf,'-property','FontName'),'FontName','Arial')
