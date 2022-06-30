function change_tickTextColor(ax,color,varargin)
% Change tick label color without changing tick mark color
% created by: Trine Frisbæk Hansen, 2022
if ismember('x',varargin)
    ticklabels_x = ax.XTickLabel;
    for i = 1:length(ticklabels_x)
        ax.XTickLabel{i} = ['\color[rgb]',color ax.XTickLabel{i}];
    end
end

if ismember('y',varargin)
    ticklabels_y = ax.YTickLabel;
    for i = 1:length(ticklabels_y)
        ax.YTickLabel{i} = ['\color[rgb]',color ax.YTickLabel{i}];
    end
end

end