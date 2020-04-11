function PlotPStay(PStay,Fig)
if nargin<2
    a=figure();
    Fig.Fig=a;
end
if isnumeric(Fig)
    Temp=Fig;
    clear Fig
    Fig.Fig=Temp;
end
if ~isfield(Fig,'AddLegend')
    Fig.AddLegend=true;
end
if ~isfield(Fig,'Legend')
    Fig.Legend={'Common','Rare'};
end
if ~isfield(Fig,'YLim')
    Fig.YLim=[0,1];
end
if ~isfield(Fig,'TextSize')
    Fig.TextSize=14;
end
if ~isfield(Fig,'Title')
    Fig.Title='';
end
MeanPStay=mean(PStay,3);
STDPStay=std(PStay,0,3);



if isfield(Fig,'Fig')
    figure(Fig.Fig)
else
    figure()
end

if isfield(Fig,'SubFig')
    if length(Fig.SubFig)==3
        subplot(Fig.SubFig{1},Fig.SubFig{2},Fig.SubFig{3})
    else
        subplot(Fig.SubFig)
    end
end

b=bar(MeanPStay,1);
hold on;
h=errorbar([1,2]-0.15,MeanPStay(:,1),STDPStay(:,1),'r','color','black','linewidth',3);
set(h,'linestyle','none');
h=errorbar([1,2]+0.15,MeanPStay(:,2),STDPStay(:,2),'r','color','black','linewidth',3);
set(h,'linestyle','none');
hold off;
b(1).FaceColor = 'b';
b(2).FaceColor = 'r';
set(gca,'XTickLabel',{'Rewarded','Unrewarded'})
if Fig.AddLegend
    legend(Fig.Legend)
end
ylim(Fig.YLim)
if ~isempty(Fig.Title)
%     if isfield(Fig,'SubFig')
%         Yloc=Fig.YLim(2)+0.1*(Fig.YLim(2)-Fig.YLim(1));
%         text(1.5,Yloc,Fig.Title,'FontSize',Fig.TextSize,'HorizontalAlignment','center')
%     else
        title(Fig.Title)
%     end
end
set(gca,'FontSize',Fig.TextSize)
if isfield(Fig,'Position')
    set(Fig.Fig,'position',Fig.Position);
end