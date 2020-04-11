function Fig=PlotPerformanceBoxLegendV2(Fig)
%% Check Figure handel
if nargin<1
    a=figure();
    Fig.Fig=a;
end
if isnumeric(Fig)
    Temp=Fig;
    clear Fig
    Fig.Fig=Temp;
end
%% Text
if ~isfield(Fig,'TextSize')
    Fig.TextSize=14;
end
%%
if ~isfield(Fig,'AreaLegendsName')
    Fig.AreaLegendsName(1,:)={'Extreme Effect','Considerable Error','Transition','Slight Error','Tolerable'};
    Fig.AreaLegendsName(2,:)={11,1,2,3,10};
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
cla;
%%
x=[0.1,0.3,0.3,0.1,0.1];
y=[0.1,0.1,0.2,0.2,0.1]-0.05;
hold on
for i=1:5
fill(x,y,Fig.ColorMAP(Fig.AreaLegendsName{2,i},:))
text(0.4,y(1)+0.05,Fig.AreaLegendsName{1,i})
y=y+0.2;
end
hold off
colormap(Fig.ColorMAP);
caxis(Fig.ColorRenge);

set(gca,'Visible','off')
xlim([0,1]);
ylim([0,1]);

