function plotfig2(ax,D,p,testcase,testdescr,mass)
%the one ken likes
ug_to_uM = 1/30.97; % conversion from ugP/l to Molar
sweep=D(:,1:p.Nbins,:);
sweep_mean=squeeze(median(sweep,1));
sweep_mean_log=log10(sweep_mean);
Contours = logspace(log10(10^(-5)),log10(100),20);
Contours_plot = 0:5:100;
contourf(p.m(3:end), p.N0 * ug_to_uM, sweep_mean_log,20,'LineStyle','none');
colorLim = ax.CLim;
hold on

% load('CustomColormap1.mat')
% colormap(CustomColormap1)
axis tight
hold on
set(gca,'xscale','log','yscale','log','XTick',10.^(-8:2))
set(gca, 'TickDir', 'out')
set(gca,'YTick',10.^(-3:0))
ymin=3.5*10^(-4);
ymax=1.1*10^0;
figmax=10^1;
ylim([ymin ymax])
ymin=3.5*10^(-4);

for iiii=1:3
    plot([mass(iiii) mass(iiii)],[ymin ymax],'w','LineWidth',1);
end
% plot([p.m(3) max(p.m)],[ymax ymax],'w','LineWidth',1);
[~,h]=contour(p.m(3:end), p.N0 * ug_to_uM, sweep_mean_log,20,'LineColor','w','LineStyle',':');
h.LevelList=h.LevelList(10:end);


% t=title(['Case nr. ', num2str(testcase), testdescr{1}]);
switch testcase
    case 1
        tplace= 0.783393501805057;
    case 2
        tplace= 0.6;
    case 3
        tplace= 0.4;
    case 4
        tplace= 0.2;
end
annotation(gcf,'textbox',...
    [0.29 tplace 0.51029411764706 0.0204572803850783],...
    'String',{['Case nr. ', num2str(testcase), testdescr{1}]},...
    'FontWeight','bold',...
    'FitBoxToText','off',...
    'Color','w',...
    'EdgeColor','none',...
    'HorizontalAlignment','right');





% drawnow
% ax=gca;
set(gca,'Color',[0.2392 0.1490 0.6588]);

switch testcase
    case 1
        % Plankton names
        strings={'Microplankton';'Nanoplankton';'Picoplankton'};
        pos1=[0.163101715686274 0.366900735294116 0.573457107843136];
        pos3=[0.96 0.0760833333333334 0.0149551345962109];
        for i=1:3
            
            annotation(gcf,'textbox',...
                [pos1(i) pos3],...
                'Color','k','String',strings{i},...
                'FontAngle','italic',...
                'FitBoxToText','off',...
                'EdgeColor','none');
        end
end


caxis([log10(10^(-3)),log10(100)])


    cb=colorbar(ax,'YTick',log10(Contours),'YTickLabel',round(Contours,1,'significant'));
    cb.Box='off';
%     cb.Location='south';
%     cb.Position(2)=0.01;
    if testcase==4
    xlabel('Cell mass ({\mu}g_C)')
    % cb=colorbar(ax,'YTick',log10(Contours),'YTickLabel',round(Contours,1,'significant'),'Location','southoutside');
    % cb = colorbar('Location','southoutside');
    % cb.Position = cb.Position + [.1 0 0 0];
    
end

set(gca,'TickDir','in','XColor',[1 1 1],'YColor',[1 1 1])

ax=gca;
color='{0 0 0}';
change_tickTextColor(ax,color,'x','y')
% colorbar(cb,'Position',[0.628829656862745 0.793457656504998 0.199652777777777 0.0133407635078822])
ax.YGrid = 'on';
ax.YMinorGrid = 'on';
% ax.MinorGridLineStyle='-';
ax.XGrid = 'on';
ax.XMinorGrid = 'on';
% % ax.GridAlpha=0.4;  %0.15
% % ax.MinorGridAlpha=0.4; %0.25


ylabel('Phosphate ({\mu}M)')
ax.YLabel.Color='k';
ax.XLabel.Color='k';
plot([ax.XLim(1) ax.XLim(1) ax.XLim(2) ax.XLim(2) ax.XLim(1)],[ax.YLim(1) ax.YLim(2) ax.YLim(2) ax.YLim(1) ax.YLim(1)],'w','LineWidth',1)
end