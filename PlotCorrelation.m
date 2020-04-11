function PlotCorrelation(X,Y,Fig)
%% Check Data
    I=isnan(X) | isnan(Y);
    X(I)=[];
    Y(I)=[];
%% Check Figure handel
if nargin<3
    a=figure();
    Fig.Fig=a;
end
if isnumeric(Fig)
    Temp=Fig;
    clear Fig
    Fig.Fig=Temp;
end
%% YLim and XLim
minx=min(X);
maxx=max(X);
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
        [Fig.CorrelationValues.R,Fig.CorrelationValues.P]=corrcoef(X',Y');
    else
        if ~isfield(Fig.CorrelationValues,'R')
            Fig.CorrelationValues.R=corrcoef(X',Y');
        end
        if ~isfield(Fig.CorrelationValues,'P')
            [~,Fig.CorrelationValues.P]=corrcoef(X',Y');
        end
    end
    if ~isfield(Fig,'TypeValuesPos')
        Fig.TypeValuesPos=[Fig.XLim(1)+0.5*(Fig.XLim(2)-Fig.XLim(1)),Fig.YLim(1)+0.1*(Fig.YLim(2)-Fig.YLim(1))];
    end
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
scatter(X,Y,'filled')
if Fig.AddLine
    FitLin = fit(X,Y,'poly1');
    hold on
    plot(Fig.XLim,FitLin(Fig.XLim))
    hold off
end
if Fig.TypeValues
text(Fig.TypeValuesPos(1),Fig.TypeValuesPos(2),sprintf('r=%3.2f , p=%4.3f',Fig.CorrelationValues.R(2),Fig.CorrelationValues.P(2)),'FontSize',Fig.TextSize-2)
end
if ~isempty(Fig.Title)
    title(Fig.Title)
end
if ~isempty(Fig.YLabel)
    ylabel(Fig.YLabel)
end
if ~isempty(Fig.XLabel)
    xlabel(Fig.XLabel)
end
ylim(Fig.YLim);
xlim(Fig.XLim);
set(gca,'FontSize',Fig.TextSize)
if isfield(Fig,'Position')
    set(Fig.Fig,'position',Fig.Position);
end