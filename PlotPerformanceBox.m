function Fig=PlotPerformanceBox(X,Y,Fig)
%chek the performance of how much X is siilar to Y
% Fig = PlotPerformanceBox(X,Y,Fig)

% For Check The Plotter !
% load('Temp')
% nargin=3;
% Fig=1;
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
    Fig.AddLine=false;
end
if ~isfield(Fig,'TextSize')
    Fig.TextSize=14;
end
if ~isfield(Fig,'PercentageTextSize')
    Fig.PercentageTextSize=Fig.TextSize-2;
end
if ~isfield(Fig,'PercentageTextStyle')
    Fig.PercentageTextStyle='%5.2f';
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
    Fig.TypeValues=false;
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
%% Box Values
%% Extract Reagons Percentage
%    <------A------> <----B----> <------A------->\
%    ____________________________________________ \T
% ^ |                                        /   | \
% C |____________________11________________/    /|
% ^ |               |           |   3    /    /  |
% ' |               |           |      /    /    |
% A"|       1       |     2     |    /    /      |
% ' |               |           |  /    /    3   |
% ' |               |           |/    /          |
% - |_______________|__________/    /____________|
% ^ |               |        /    /              |
% ' |               |  5   /    /                |
% B |      4        |    /    / |       6        |
% ' |               |  / 10 /   |                |
% ' |               |/    /  5  |                |
% - |______________/    /_______|________________|
% ^ |            /    /         |                |
% ' |          /    /           |                |
% ' |  7     /    / |           |                |
% A"|      /    /   |           |                |
% ' |    /    /  7  |     8     |        9       |
% _ |  /    /____________________________________|
% C |/    /                                      |
% - |___/________________12______________________|
% T  .
% * B=1-2xA
% * A" = A-C

if ~isfield(Fig,'AreaNum')
    Fig.AreaNum=12;
end
switch Fig.AreaNum
    case 1
        Fig.AreaA=2;
        Fig.AreaB=0;
        Fig.AreaC=0;
        Fig.AreaT=0;
    case 4
        Fig.AreaA=0.5;
        Fig.AreaB=0;
        Fig.AreaC=0;
        Fig.AreaT=0;
    case 9
        if ~isfield(Fig,'AreaA')
            Fig.AreaA=0.45;
        end
        Fig.AreaB=1-2*Fig.AreaA;
        Fig.AreaC=0;
        Fig.AreaT=0;
    case 10
        if ~isfield(Fig,'AreaA')
            Fig.AreaA=0.45;
        end
        Fig.AreaB=1-2*Fig.AreaA;
        Fig.AreaC=0;
        if ~isfield(Fig,'AreaT')
            Fig.AreaT=0.1;
        end
    case 11
        if ~isfield(Fig,'AreaA')
            Fig.AreaA=0.45;
        end
        Fig.AreaB=1-2*Fig.AreaA;
        if ~isfield(Fig,'AreaC')
            Fig.AreaC=0.01;
        end
        Fig.AreaT=0;
    case 12
        if ~isfield(Fig,'AreaA')
            Fig.AreaA=0.45;
        end
        Fig.AreaB=1-2*Fig.AreaA;
        if ~isfield(Fig,'AreaC')
            Fig.AreaC=0.01;
        end
        if ~isfield(Fig,'AreaT')
            Fig.AreaT=0.1;
        end
    otherwise
        Fig.AreaA=2;
        Fig.AreaB=0;
        Fig.AreaC=0;
        Fig.AreaT=0;
end
A=Fig.AreaA;
B=Fig.AreaB;
Fig.NodesIndex=zeros(size(X));
Fig.NodesIndex(          X<A           & Y>=A+B )=1;
Fig.NodesIndex(X>=A    & X<A+B         & Y>=A+B )=2;
Fig.NodesIndex(X>=A+B                  & Y>=A+B )=3;
Fig.NodesIndex(          X<A   & Y<A+B & Y>=A   )=4;
Fig.NodesIndex(X>=A    & X<A+B & Y<A+B & Y>=A   )=5;
Fig.NodesIndex(X>=A+B          & Y<A+B & Y>=A   )=6;
Fig.NodesIndex(          X<A   & Y<A            )=7;
Fig.NodesIndex(X>=A    & X<A+B & Y<A            )=8;
Fig.NodesIndex(X>=A+B          & Y<A            )=9;
Fig.NodesIndex(Y<Fig.AreaC)=12;
Fig.NodesIndex(Y>(2*A+B-Fig.AreaC))=11;
Fig.NodesIndex(abs(X-Y)<=Fig.AreaT)=10;

if ~isfield(Fig,'PlotBoundryLines')
    Fig.PlotBoundryLines=true;
end
if ~isfield(Fig,'TypePercentage')
    Fig.TypePercentage=true;
end
if ~isfield(Fig,'CAreaPercentageTreshold')
    Fig.CAreaPercentageTreshold=1;
end
if ~isfield(Fig,'CenterAreaPercentageTreshold')
    Fig.CenterAreaPercentageTreshold=1;
end
if Fig.PlotBoundryLines
    if ~isfield(Fig,'BoundryLinesStyle')
        Fig.BoundryLinesStyle='k';
    end
    if ~isfield(Fig,'BoundryLinesSize')
        Fig.BoundryLinesSize=0.5;
    end
end
%% Color Map and Colorbar
if ~isfield(Fig,'ColorMAP')
    Fig.ColorMAP=[0.9,0.1,0.1
                  0.8,0.4,0.8
                  0.4,0.4,1.0
                  0.8,0.4,0.8
                  0.0,0.5,0.0
                  0.8,0.4,0.8
                  0.4,0.4,1.0
                  0.8,0.4,0.8
                  0.9,0.1,0.1
                  0.0,1.0,0.0
                  0.1,0.1,0.1
                  0.1,0.1,0.1];
end
if ~isfield(Fig,'ColorRenge')
    Fig.ColorRenge=[1,12];
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
scatter3(X,Y,Fig.NodesIndex,Fig.ScatterSize,Fig.NodesIndex,'filled')

view(2);
colormap(Fig.ColorMAP);
caxis(Fig.ColorRenge)
if Fig.AddLine
    FitLin = fit(X,Y,'poly1');
    hold on
    plot3(Fig.XLim,FitLin(Fig.XLim),[13,13],'--k')
    hold off
end
if Fig.PlotBoundryLines
    A=Fig.AreaA;
    B=Fig.AreaB;
    C=Fig.AreaC;
    T=Fig.AreaT;
    Bot=0;
    Top=1;
    
    hold on
    x=[];
    y=[];
    if T>0 && T<=B
        x=[      Bot  ,A    ,A  ,Bot,Bot  ]; %x1
        y=[      Top-C,Top-C,A+B,A+B,Top-C]; %y1
        x=[x,NaN,A  ,A    ,A+B  ,A+B  ,A+B-T,A  ];%x2
        y=[y,NaN,A+B,Top-C,Top-C,A+B+T,A+B  ,A+B];%y2
        x=[x,NaN,A+B  ,A+B  ,Top-C-T,A+B  ,NaN,A+B+T,Top,Top  ,A+B+T];%x3
        y=[y,NaN,Top-C,A+B+T,Top-C  ,Top-C,NaN,A+B  ,A+B,Top-T,A+B  ];%y3
        x=[x,NaN,Bot,Bot,A  ,A  ,A-T,Bot];%x4
        y=[y,NaN,A  ,A+B,A+B,A+T,A  ,A  ];%y4
        x=[x,NaN,A  ,A  ,A+B-T,A  ,NaN,A+B  ,A+T,A+B,A+B  ];%x5
        y=[y,NaN,A+B,A+T,A+B  ,A+B,NaN,A+B-T,A  ,A  ,A+B-T];%y5
        x=[x,NaN,A+B,Top,Top,A+B+T,A+B  ,A+B];%x6
        y=[y,NaN,A  ,A  ,A+B,A+B  ,A+B-T,A  ];%y6
        x=[x,NaN,Bot,Bot,A-T,Bot,NaN,T+C  ,A    ,A  ,T+C  ];%x7
        y=[y,NaN,T  ,A  ,A  ,T  ,NaN,Bot+C,Bot+C,A-T,Bot+C];%y7
        x=[x,NaN,A    ,A+B  ,A+B,A+T,A  ,A    ];%x8
        y=[y,NaN,Bot+C,Bot+C,A  ,A  ,A-T,Bot+C];%y8
        x=[x,NaN,A+B  ,Top  ,Top,A+B,A+B  ];%x9
        y=[y,NaN,Bot+C,Bot+C,A  ,A  ,Bot+C];%y9
        x=[x,NaN,T-C  ,Top  ,Top  ,Top+C-T,Bot,Bot  ,T-C  ];%x10
        y=[y,NaN,Bot-C,Top-T,Top+C,Top+C  ,T  ,Bot-C,Bot-C];%y10
        x=[x,NaN,Bot  ,Top-C-T,Top+C-T,Bot  ,Bot  ];%x11
        y=[y,NaN,Top-C,Top-C  ,Top+C  ,Top+C,Top-C];%y11
        x=[x,NaN,T-C  ,Top  ,Top  ,T+C  ,T-C  ];%x12
        y=[y,NaN,Bot-C,Bot-C,Bot+C,Bot+C,Bot-C];%y12
    elseif T>B
        x=[Bot  ,A    ,A  ,A+B-T,Bot,Bot  ]; %x1
        y=[Top-C,Top-C,A+T,A+B  ,A+B,Top-C]; %y1
        x=[x,NaN,A    ,A+B  ,A+B  ,A  ,A    ];%x2
        y=[y,NaN,Top-C,Top-C,A+B+T,A+T,Top-C];%y2
        x=[x,NaN,A+B  ,A+B  ,Top-C-T,A+B  ,NaN,A+B+T,Top,Top  ,A+B+T];%x3
        y=[y,NaN,Top-C,A+B+T,Top-C  ,Top-C,NaN,A+B  ,A+B,Top-T,A+B  ];%y3
        x=[x,NaN,Bot,Bot,A+B-T,A-T,Bot];%x4
        y=[y,NaN,A  ,A+B,A+B  ,A  ,A  ];%y4
        %     x=[x,NaN];%x5
        %     y=[y,NaN];%y5
        x=[x,NaN,A+T,Top,Top,A+B+T,A+T];%x6
        y=[y,NaN,A  ,A  ,A+B,A+B  ,A  ];%y6
        x=[x,NaN,Bot,Bot,A-T,Bot,NaN,T+C  ,A    ,A  ,T+C  ];%x7
        y=[y,NaN,T  ,A  ,A  ,T  ,NaN,Bot+C,Bot+C,A-T,Bot+C];%y7
        x=[x,NaN,A    ,A+B  ,A+B  ,A  ,A    ];%x8
        y=[y,NaN,Bot+C,Bot+C,A+B-T,A-T,Bot+C];%y8
        x=[x,NaN,A+B  ,Top  ,Top,A+T,A+B  ,A+B  ];%x9
        y=[y,NaN,Bot+C,Bot+C,A  ,A  ,A+B-T,Bot+C];%y9
        x=[x,NaN,T-C  ,Top  ,Top  ,Top+C-T,Bot,Bot  ,T-C  ];%x10
        y=[y,NaN,Bot-C,Top-T,Top+C,Top+C  ,T  ,Bot-C,Bot-C];%y10
        x=[x,NaN,Bot  ,Top-C-T,Top+C-T,Bot  ,Bot  ];%x11
        y=[y,NaN,Top-C,Top-C  ,Top+C  ,Top+C,Top-C];%y11
        x=[x,NaN,T-C  ,Top  ,Top  ,T+C  ,T-C  ];%x12
        y=[y,NaN,Bot-C,Bot-C,Bot+C,Bot+C,Bot-C];%y12
    elseif T==0
        x=[      Bot  ,A    ,A    ,Bot  ,Bot  ];%x1
        y=[      Top-C,Top-C,A+B  ,A+B  ,Top-C];%y1
        x=[x,NaN,A    ,A    ,A+B  ,A+B  ,A    ];%x2
        y=[y,NaN,A+B  ,Top-C,Top-C,A+B  ,A+B  ];%y2
        x=[x,NaN,A+B  ,A+B  ,Top  ,Top  ,A+B  ];%x3
        y=[y,NaN,Top-C,A+B  ,A+B  ,Top-C,Top-C];%y3
        x=[x,NaN,Bot  ,Bot  ,A    ,A    ,Bot  ];%x4
        y=[y,NaN,A    ,A+B  ,A+B  ,A    ,A    ];%y4
        x=[x,NaN,A    ,A    ,A+B  ,A+B  ,A    ];%x5
        y=[y,NaN,A    ,A+B  ,A+B  ,A    ,A    ];%y5
        x=[x,NaN,A+B  ,Top  ,Top  ,A+B  ,A+B  ];%x6
        y=[y,NaN,A    ,A    ,A+B  ,A+B  ,A    ];%y6
        x=[x,NaN,Bot  ,Bot  ,A    ,A    ,Bot  ];%x7
        y=[y,NaN,Bot+C,A    ,A    ,Bot+C,Bot+C];%y7
        x=[x,NaN,A    ,A+B  ,A+B  ,A    ,A    ];%x8
        y=[y,NaN,Bot+C,Bot+C,A    ,A    ,Bot+C];%y8
        x=[x,NaN,A+B  ,Top  ,Top  ,A+B  ,A+B  ];%x9
        y=[y,NaN,Bot+C,Bot+C,A    ,A    ,Bot+C];%y9
        x=[x,NaN,Bot  ,Top  ,Top  ,Bot  ,Bot  ];%x11
        y=[y,NaN,Top-C,Top-C,Top+C,Top+C,Top-C];%y11
        x=[x,NaN,Bot  ,Top  ,Top  ,Bot  ,Bot  ];%x12
        y=[y,NaN,Bot-C,Bot-C,Bot+C,Bot+C,Bot-C];%y12
    end
    z=13*ones(size(x));
    z(isnan(x))=NaN;
    plot3(x,y,z,Fig.BoundryLinesStyle,'LineWidth',Fig.BoundryLinesSize)
    hold off
end
if Fig.TypePercentage
    A=Fig.AreaA;
    B=Fig.AreaB;
    C=Fig.AreaC;
    T=Fig.AreaT;
    Bot=0;
    Top=1;
    e=0.05;
    Percentage=zeros(12,1);
    for i=1:12
        Percentage(i)=nnz(Fig.NodesIndex==i);
    end
    Percentage=Percentage/sum(Percentage)*100;
    if Percentage(5)<Fig.CenterAreaPercentageTreshold
        x5=NaN;
        y5=NaN;
        F5=false;
        Fx5=NaN;
        Fy5=NaN;
        A5=0;
    else
        x5=A+B-e;
        y5=A+B-e;
        F5=true;
        Fx5=Bot-e;
        Fy5=A+B/2;
        A5=90;
    end
    if Percentage(12)<Fig.CAreaPercentageTreshold
        x11=NaN;
        y11=NaN;
        F11=false;
        Fx11=NaN;
        Fy11=NaN;
        A11=0;
    else
        x11=B+T+e;
        y11=Top+0.03;
        F11=false;
        Fx11=NaN;
        Fy11=NaN;
        A11=0;
    end
    if Percentage(12)<Fig.CAreaPercentageTreshold
        x12=NaN;
        y12=NaN;
        F12=false;
        Fx12=NaN;
        Fy12=NaN;
        A12=0;
    else
        x12=Top-T-A/3;
        y12=Bot-0.05;
        F12=false;
        Fx12=NaN;
        Fy12=NaN;
        A12=0;
    end
%     if T>0 && T<=B
        x   =[A/2    ,A+B/2  ,1.5*A+B+T,A/2  ,x5 ,1.5*A+B,A/2-T,A+B/2,1.5*A+B,A+B/2,x11 ,x12 ];
        y   =[Top-A/2,Top-A/2,Top-A*0.8,A+B/2,y5 ,A+B/2  ,4*A/5,A/2  ,A/2    ,A+B/2,y11 ,y12 ];
        Flag=[false  ,false  ,false    ,false,F5 ,false  ,false,false,false  ,false,F11 ,F12 ];
        Flgx=[0      ,0      ,0        ,0    ,Fx5,0      ,0    ,0    ,0      ,0    ,Fx11,Fx12];
        Flgy=[0      ,0      ,0        ,0    ,Fy5,0      ,0    ,0    ,0      ,0    ,Fy11,Fy12];
        Angl=[0      ,90     ,0        ,0    ,A5 ,0      ,0    ,90   ,0      ,45   ,A11 ,A12 ];
%     elseif T>B
%     elseif T==0
%     end
    for i=1:length(x)
        if ~Flag(i)
        text(   x(i),   y(i),13,[num2str(Percentage(i),Fig.PercentageTextStyle),'%'],'FontWeight','Bold','FontSize',Fig.TextSize,'HorizontalAlignment','center','Rotation',Angl(i),'Color','k');%[1,1,1]-Fig.ColorMAP(i,:))
        else
        hold on
        plot3([x(i),Flgx(i)+(0.3*(x(i)-Flgx(i)))],[y(i),Flgy(i)],[13,13],'--k')
        hold off
        text(Flgx(i),Flgy(i),13,[num2str(Percentage(i),Fig.PercentageTextStyle),'%'],'FontSize',Fig.TextSize,'HorizontalAlignment','center','Rotation',Angl(i),'Color','k');%[1,1,1]-Fig.ColorMAP(i,:))
        end
    end
end
if Fig.TypeValues
    text(Fig.TypeValuesPos(1),Fig.TypeValuesPos(2),sprintf('r=%3.2f , p=%4.3f',Fig.CorrelationValues.R(2),Fig.CorrelationValues.P(2)),'FontSize',Fig.TextSize-2)
end
if ~isempty(Fig.Title)
    title(Fig.Title,'interpreter','tex');%,'FontWeight','normal')
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