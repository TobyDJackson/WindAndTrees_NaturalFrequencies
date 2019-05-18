% This script is part of Jackson et al 2019  'An architectural understanding of natural sway frequencies in trees'
% Specifically, this script creates figures 3 and 5 - summaries of the field and model data 

%%   Import data and set up definitions
Import_Summary_Field_Data

UK=find(strcmp(FD.Location,'UK'));
Borneo=find(strcmp(FD.Location,'Borneo'));
Oxford=find(strcmp(FD.Location,'UK - Oxfordshire'));
USA=find(strcmp(FD.Location,'USA - Connecticut'));
MA_forest=find(strcmp(FD.Location,'MA - USA - forest'));
USA=cat(1,USA,MA_forest);
Brazil=find(strcmp(FD.Location,'Brazil - Manaus'));
Canada=find(strcmp(FD.Location,'Canada'));
Nottingham=find(strcmp(FD.Location,'UK - Nottingham'));
MA_open=find(strcmp(FD.Location,'MA USA'));
Singapore=find(strcmp(FD.Location,'Singapore'));
Aus=find(strcmp(FD.Location,'Australia'));


colors= brewermap(10,'RdGy');
colors1= brewermap(9,'GnBu');
colors2=brewermap(10,'PuOr');
colors3=brewermap(10,'BrBg');

legend_size=7;
label_size=14;
axis_size=8;

%% Figure 3
xaxis=FD.DBH./(100*FD.Height.^2);
yaxis=FD.fo;

subplot(1,2,1)
scatter(xaxis(Oxford),yaxis(Oxford),15,'+','MarkerEdgeColor',colors(3,:),'LineWidth',1)
hold on
scatter(xaxis(USA),yaxis(USA),15,'+','MarkerEdgeColor',colors2(8,:),'LineWidth',1)
scatter(xaxis(Brazil),yaxis(Brazil),12,'MarkerEdgeColor',colors3(2,:),'MarkerFaceColor',colors3(2,:))
scatter(xaxis(Borneo),yaxis(Borneo),12,'MarkerEdgeColor',colors3(9,:),'MarkerFaceColor',colors3(9,:))
h=legend('Temperate - UK','Temperate - USA','Tropical - Brazil', 'Tropical - Malaysia', 'Location','NorthWest'); legend boxoff; set(h, 'FontSize', legend_size);
set(gca, 'FontName', 'Helvetica','FontSize', axis_size)
xlabel('\itdbh / H^2'); ylabel('\itf_0  (Hz)')
yticks([0.1 0.2 0.3 0.4])
htext=text(-0.5e-3,0.5,'A'); set(htext, 'FontSize', label_size);
ylim([0.05 0.5])

subplot(1,2,2)
h1=scatter(xaxis(Nottingham),yaxis(Nottingham),20,'s','MarkerEdgeColor',colors1(5,:), 'LineWidth',1);
hold on
h2=scatter(xaxis(MA_open),yaxis(MA_open),20,'s','MarkerEdgeColor',colors(7,:), 'LineWidth',1);
h3=scatter(xaxis(Singapore),yaxis(Singapore),20,'s','MarkerEdgeColor',colors(1,:),'LineWidth',1);
h4=scatter(xaxis(Aus),yaxis(Aus),20,'s','MarkerEdgeColor',colors1(9,:), 'LineWidth',1);
h5=scatter(xaxis(UK),yaxis(UK),15,'.','MarkerEdgeColor',colors2(1,:),'MarkerEdgeAlpha',0.5);
h6=scatter(xaxis(Canada),yaxis(Canada),15,'.','MarkerEdgeColor',colors(7,:),'MarkerEdgeAlpha',0.8);
set(gca, 'FontName', 'Helvetica', 'FontSize', axis_size);
xlabel('\itdbh / H^2'); ylabel('\itf_0  (Hz)')
h=legend([h3 h4 h1 h2 h6 h5], 'Open-grown - Singapore','Open-grown - Australia','Open-grown - UK','Open-grown - USA',...
    'Conifer - North America', 'Conifer - UK','Location','NorthWest'); legend boxoff; set(h, 'FontSize', legend_size);
htext=text(-0.9e-3,2.1,'B'); set(htext, 'FontSize', label_size);
ylim([0 2.1])


%% Load and sort model data for Figure 5
Import_Summary_Model_Data

MD(MD.TotalVolume>=100,:)=[];  MD(MD.CVR>=20,:)=[]; % Remove 2 outliers
MD(find(isnan(MD.fo1)==1),:)=[]; % Remove failed simulations (collapsed under gravity)

% optional exclude large open grown trees (results in parenthesis in table 1)
%MD(strcmp(MD.Location,'London')==1 & MD.fo>0.4,:)=[]; 
%MD(strcmp(MD.Location,'London')==1 & MD.Beam>2.2e-3,:)=[];  

UK=find(strcmp(MD.Location,'UK'));
Australia=find(strcmp(MD.Location,'Australia'));
Brazil=find(strcmp(MD.Location,'Brazil'));
Gabon=find(strcmp(MD.Location,'Gabon'));
Guyana=find(strcmp(MD.Location,'Guyana'));
Indonesia=find(strcmp(MD.Location,'Indonesia'));
FrenchG=find(strcmp(MD.Location,'French Guiana'));
Malaysia=find(strcmp(MD.Location,'Malaysia'));
London=find(strcmp(MD.Location,'London'));

temperate=cat(1,UK,Australia);
tropical=cat(1,Brazil, Gabon, Guyana,Indonesia,FrenchG,Malaysia);

colors= brewermap(10,'PuOr');
colors1= brewermap(8,'Accent');
colors2=brewermap(12,'Paired');
dark2=brewermap(8,'dark2');

figure
legend_size=7;
label_size=14;
axis_size=8;

%% Plot cantilever beam approximation for model data

yvariable=MD.fo1;
xvariable=MD.Beam;
ps=8;

subplot(2,3,1)
h1=scatter(xvariable(Guyana),yvariable(Guyana),ps,'filled','MarkerFaceColor',dark2(1,:),'MarkerFaceAlpha',1);
hold on
h2=scatter(xvariable(Indonesia),yvariable(Indonesia),ps,'filled','MarkerFaceColor',dark2(2,:),'MarkerFaceAlpha',1);
h3=scatter(xvariable(Brazil),yvariable(Brazil),ps,'filled','MarkerFaceColor',dark2(3,:),'MarkerFaceAlpha',1);
h4=scatter(xvariable(Gabon),yvariable(Gabon),ps,'filled','MarkerFaceColor',dark2(4,:),'MarkerFaceAlpha',1);
h5=scatter(xvariable(FrenchG),yvariable(FrenchG),ps,'filled','MarkerFaceColor',dark2(5,:),'MarkerFaceAlpha',1);
h6=scatter(xvariable(Malaysia),yvariable(Malaysia),ps,'filled','MarkerFaceColor',dark2(6,:),'MarkerFaceAlpha',1);
set(gca, 'FontName', 'Helvetica', 'FontSize', axis_size)
htext=text(-0.3e-3,0.6,'A'); set(htext, 'FontSize', label_size);
title('Tropical trees','FontSize',10)
xlabel('\itdbh / H^2 '); ylabel('\itf_0  (Hz)')
axis([0 1.6e-3 0 0.6])

subplot(2,3,2)
h1=scatter(xvariable(UK),yvariable(UK),20,'+','MarkerEdgeColor',colors1(3,:),'LineWidth',1,'MarkerEdgeAlpha',0.8);
hold on
h2=scatter(xvariable(Australia),yvariable(Australia),20,'+','MarkerEdgeColor',colors2(1,:),'LineWidth',1,'MarkerEdgeAlpha',0.8);
set(gca, 'FontName', 'Helvetica', 'FontSize', axis_size)
htext=text(-1.4e-3,2.5,'B'); set(htext, 'FontSize', label_size);
title('Temperate trees','FontSize',10)
xlabel('\itdbh / H^2 '); ylabel('\itf_0  (Hz)')
axis([0 7e-3 0 2.5])

subplot(2,3,3)
h1=scatter(xvariable(London),yvariable(London),15,'s','MarkerEdgeColor',dark2(8,:),'LineWidth',1);
set(gca, 'FontName', 'Helvetica', 'FontSize', axis_size)
htext=text(-1.3e-3,4,'C'); set(htext, 'FontSize', label_size);
title('Open-grown trees','FontSize',10)
xlabel('\itdbh / H^2'); ylabel('\itf_0  (Hz)')
axis([0 8e-3 0 4])


robust='off';
modelspec='fo1~Beam+Beam:(CVR+CrownAsym+AspectRatio)';
subplot(2,3,4)
tbl=MD(tropical,:);
lm=fitlm(tbl,modelspec,'RobustOpts',robust); 
yvariable=tbl.fo1; temp=lm.Coefficients.Estimate;
xvariable=0.01*(tbl.Beam*temp(2)+tbl.Beam.*tbl.AspectRatio*temp(3)+tbl.Beam.*tbl.CrownAsym*temp(4)+tbl.Beam.*tbl.CVR*temp(5)); 
t=length(temperate);
h1=scatter(xvariable(Guyana-t),yvariable(Guyana-t),ps,'filled','MarkerFaceColor',dark2(1,:),'MarkerFaceAlpha',1);
hold on
h2=scatter(xvariable(Indonesia-t),yvariable(Indonesia-t),ps,'filled','MarkerFaceColor',dark2(2,:),'MarkerFaceAlpha',1);
h3=scatter(xvariable(Brazil-t),yvariable(Brazil-t),ps,'filled','MarkerFaceColor',dark2(3,:),'MarkerFaceAlpha',1);
h4=scatter(xvariable(Gabon-t),yvariable(Gabon-t),ps,'filled','MarkerFaceColor',dark2(4,:),'MarkerFaceAlpha',1);
h5=scatter(xvariable(FrenchG-t),yvariable(FrenchG-t),ps,'filled','MarkerFaceColor',dark2(5,:),'MarkerFaceAlpha',1);
h6=scatter(xvariable(Malaysia-t),yvariable(Malaysia-t),ps,'filled','MarkerFaceColor',dark2(6,:),'MarkerFaceAlpha',1);
h=legend( [h1 h2 h5 h6 h4 h3],'Guyana','Indonesia', 'French Guiana','Malaysia' , 'Gabon',  'Brazil','Location','NorthWest'); legend boxoff; set(h, 'FontSize', legend_size);
set(gca, 'FontName', 'Helvetica', 'FontSize', axis_size)
htext=text(-0.75e-3,0.6,'D'); set(htext, 'FontSize', label_size);
axis([0 3.5e-3 0 0.6])
xlabel('\it(dbh / H^2) x \itA','Interpreter','Tex'); ylabel('\itf_0  (Hz)','Interpreter','Tex')

subplot(2,3,5)
tbl=MD(temperate,:);
lm=fitlm(tbl,modelspec,'RobustOpts',robust); 
yvariable=tbl.fo1; temp=lm.Coefficients.Estimate;
xvariable=0.01*(tbl.Beam*temp(2)+tbl.Beam.*tbl.AspectRatio*temp(3)+tbl.Beam.*tbl.CrownAsym*temp(4)+tbl.Beam.*tbl.CVR*temp(5)); 
h1=scatter(xvariable(UK),yvariable(UK),20,'+','MarkerEdgeColor',colors1(3,:),'LineWidth',1,'MarkerEdgeAlpha',0.8);
hold on
h2=scatter(xvariable(Australia),yvariable(Australia),20,'+','MarkerEdgeColor',colors2(1,:),'LineWidth',1,'MarkerEdgeAlpha',0.8);
h=legend([h1 h2],'UK','Australia','Location','NorthWest'); legend boxoff; set(h, 'FontSize', legend_size);
set(gca, 'FontName', 'Helvetica', 'FontSize', axis_size)
htext=text(-4e-3,2.5,'E'); set(htext, 'FontSize', label_size);
axis([0 20e-3 0 2.5])
xlabel('\it(dbh / H^2) x \itA','Interpreter','Tex'); ylabel('\itf_0  (Hz)','Interpreter','Tex')


subplot(2,3,6)
tbl=MD(London,:);
lm=fitlm(tbl,modelspec,'RobustOpts',robust); 
yvariable=tbl.fo1; temp=lm.Coefficients.Estimate;
xvariable=0.01*(tbl.Beam*temp(2)+tbl.Beam.*tbl.AspectRatio*temp(3)+tbl.Beam.*tbl.CrownAsym*temp(4)+tbl.Beam.*tbl.CVR*temp(5)); 
t=length(temperate)+length(tropical);
h1=scatter(xvariable(London-t),yvariable(London-t),15,'s','MarkerEdgeColor',dark2(8,:),'LineWidth',1);
set(gca, 'FontName', 'Helvetica', 'FontSize', axis_size)
htext=text(-0.007,4,'F'); set(htext, 'FontSize', label_size);
xlabel('\it(dbh / H^2) x \itA','Interpreter','Tex'); ylabel('\itf_0  (Hz)','Interpreter','Tex')
axis([0 0.04 0 4])


%% Make open grown tree insets for figure 5
yvariable=MD.fo1;
xvariable=MD.Beam;
ps=8;
axis_size=11;

subplot(1,2,1)
h1=scatter(xvariable(London),yvariable(London),15,'s','MarkerEdgeColor',dark2(8,:),'LineWidth',1);
set(gca, 'FontName', 'Helvetica', 'FontSize', axis_size)
axis([0.5e-3 2.4e-3 0 0.4])
xticks([1 2]*1e-3); 
yticks([0 0.2 0.4]);

subplot(1,2,2)
tbl=MD(London,:);
robust='off';
modelspec='fo1~Beam+Beam:(CVR+CrownAsym+AspectRatio)';
lm=fitlm(tbl,modelspec,'RobustOpts',robust); 
yvariable=tbl.fo1; temp=lm.Coefficients.Estimate;
xvariable=0.01*(tbl.Beam*temp(2)+tbl.Beam.*tbl.AspectRatio*temp(3)+tbl.Beam.*tbl.CrownAsym*temp(4)+tbl.Beam.*tbl.CVR*temp(5)); 
t=length(temperate)+length(tropical);
h1=scatter(xvariable(London-t),yvariable(London-t),15,'s','MarkerEdgeColor',dark2(8,:),'LineWidth',1);
set(gca, 'FontName', 'Helvetica', 'FontSize', axis_size)
axis([0.001 0.0072 0 0.4])
xticks([2 4 6]*1e-3); 
yticks([0 0.2 0.4]);


