function Fig=PlotDifPerformance(X1,X2,Y,Fig)
%% Check Data
    I=isnan(X1) | isnan(Y) | isnan(X2);
    X1(I)=[];
    Y(I)=[];
    X2(I)=[];
%% Check Figure handel
if nargin<4
    a=figure();
    Fig.Fig=a;
end
if isnumeric(Fig)
    Temp=Fig;
    clear Fig
    Fig.Fig=Temp;
end
%% YLim and XLim
minx=min(X1);
maxx=max(X1);
renx=max(maxx-minx,5e-3);% Avoide Zero Values
miny=min(Y);
maxy=max(Y);
reny=max(maxy-miny,5e-3);% Avoide Zero Values
if ~isfield(Fig,'MarginRate')
    Fig.MarginRate=0.1;
end
if ~isfield(Fig,'YLim')
    Fig.YLim=[miny-Fig.MarginRate*reny,maxy+Fig.MarginRate*reny];
end
if ~isfield(Fig,'XLim')
    Fig.XLim=[minx-Fig.MarginRate*renx,maxx+Fig.MarginRate*renx];
end
%% Text, Title and Labels
if ~isfield(Fig,'AddLine')
    Fig.AddLine=true;
end
if ~isfield(Fig,'TextSize')
    Fig.TextSize=14;
end
if ~isfield(Fig,'Title')
    Fig.Title='';
end
if ~isfield(Fig,'YLabel')
    Fig.YLabel='';
end
if ~isfield(Fig,'XLabel')
    Fig.XLabel='';
end
%% Corelation Values and Pos
if ~isfield(Fig,'TypeValues')
    Fig.TypeValues=true;
end
if Fig.TypeValues
    if ~isfield(Fig,'CorrelationValues')
        [Fig.CorrelationValues.R,Fig.CorrelationValues.P]=corrcoef(X1',Y');
    else
        if ~isfield(Fig.CorrelationValues,'R')
            Fig.CorrelationValues.R=corrcoef(X1',Y');
        end
        if ~isfield(Fig.CorrelationValues,'P')
            [~,Fig.CorrelationValues.P]=corrcoef(X1',Y');
        end
    end
    if ~isfield(Fig,'TypeValuesPos')
        Fig.TypeValuesPos=[Fig.XLim(1)+0.5*(Fig.XLim(2)-Fig.XLim(1)),Fig.YLim(1)+0.1*(Fig.YLim(2)-Fig.YLim(1))];
    end
end
%% Parzen Stimation
if ~isfield(Fig,'ParzenStimation')
    Fig.ParzenStimation=true;
end
if Fig.ParzenStimation
    if ~isfield(Fig,'ParzenH')
        Fig.ParzenH=0.05;
    end
    if ~isfield(Fig,'ParzenGrids')
        [Fig.ParzenGrids.MeshX,Fig.ParzenGrids.MeshY]=meshgrid(0:Fig.ParzenH:1,0:Fig.ParzenH:1);
    end
    if ~isfield(Fig,'ParzenValues')
        [Fig.ParzenValues.P,Fig.ParzenValues.PV]=ParzenWindow([Y,X1],Fig.ParzenH);
    end
end
%% Color Map and Colorbar
if ~isfield(Fig,'ColorMAP')
    Fig.ColorMAP='default';
end
if ~isfield(Fig,'ColorRenge')
    Fig.ColorRenge=[0,max(max(Fig.ParzenValues.P))];
end
if ~isfield(Fig,'ColorBar')
    Fig.ColorBar=true;
end
%% Scatter Size
if ~isfield(Fig,'ScatterSize')
    Fig.ScatterSize=2;
end
%% Correct Axis
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

%% Scatter Plot and Line
if Fig.ParzenStimation  
Extended=Fig.ParzenValues.P;
Extended(end+1,:)=Extended(end,:);
Extended(:,end+1)=Extended(:,end);
cla
surf(Fig.ParzenGrids.MeshX,Fig.ParzenGrids.MeshY,Extended,'facealpha',0.5,'edgecolor','none')
hold on
scatter3(X1,Y,ones(size(Y)),Fig.ScatterSize,Fig.ParzenValues.PV,'s')
hold off
else
scatter(X1,Y,'filled')
end
view(2);
colormap(Fig.ColorMAP);
caxis(Fig.ColorRenge)
if Fig.AddLine
    FitLin = fit(X1,Y,'poly1');
    hold on
    plot(Fig.XLim,FitLin(Fig.XLim))
    hold off
end
if Fig.TypeValues
text(Fig.TypeValuesPos(1),Fig.TypeValuesPos(2),sprintf('r=%3.2f , p=%4.3f',Fig.CorrelationValues.R(2),Fig.CorrelationValues.P(2)),'FontSize',Fig.TextSize-2)
end
if ~isempty(Fig.Title)
    title(Fig.Title,'interpreter','tex')
end
if ~isempty(Fig.YLabel)
    ylabel(Fig.YLabel)
end
if ~isempty(Fig.XLabel)
    xlabel(Fig.XLabel)
end
if Fig.ColorBar
colorbar('Location','eastoutside');
end
ylim(Fig.YLim);
xlim(Fig.XLim);
set(gca,'FontSize',Fig.TextSize)
if isfield(Fig,'Position')
    set(Fig.Fig,'position',Fig.Position);
end