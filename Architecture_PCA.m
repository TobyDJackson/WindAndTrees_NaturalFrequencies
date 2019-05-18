% This script is part of Jackson et al 2019  'An architectural understanding of natural sway frequencies in trees'
% It calculates the covariance matrix and principal components of variation in architectural indices derived from QSMs

%%   Import data and set up definitions
Import_Summary_Model_Data

MD(MD.TotalVolume>=100,:)=[];  MD(MD.CVR>=20,:)=[]; % Remove 2 outliers
MD(find(isnan(MD.fo1)==1),:)=[]; % Remove failed simulations (collapsed under gravity)

% optional exclude large open grown trees (results in parenthesis in table 1)
%MD(strcmp(MD.Location,'London')==1 & MD.fo>0.4,:)=[]; 
%MD(strcmp(MD.Location,'London')==1 & MD.Beam>2.2e-3,:)=[];  

MD(MD.DBH<=0.3,:)=[]; % Optional exclude all trees with dbh < 30 cm (used in Fig 4)

colors= brewermap(10,'PuOr');
colors1= brewermap(8,'Accent');
colors2=brewermap(12,'Paired');
dark2=brewermap(8,'dark2');

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

%% Covariance matrix (Fig S5)
in=[ MD.TreeHeight MD.DBH MD.TotalVolume MD.PathFraction  MD.AspectRatio MD.CrownArea MD.CrownAsym MD.BranchingAngle  MD.CVR ];
labels={'Height', 'dbh','Volume','Path Fraction','Aspect Ratio','Crown Area','Crown Asymmetry','Branching Angle','CVR'};

in=[ MD.TreeHeight MD.DBH MD.TotalVolume MD.PathFraction  MD.AspectRatio MD.CrownArea MD.CrownAsym MD.BranchingAngle  MD.CVR MD.fo1 MD.dom1];
labels={'Height', 'dbh','Volume','Path Fraction','Aspect Ratio','Crown Area','Crown Asymmetry','Branching Angle','CVR','{\itf_0}','{\itD_0}'};
for col=1:size(in,2)
    in(isnan(in(:,col))==1,:)=[];
end
n=size(in,2);
L=labels;
M=corr(in); 
imagesc(M); % plot the matrix
set(gca, 'YTick', 1:n); % center y-axis ticks on bins
set(gca, 'YTickLabel', L); % set y-axis labels
set(gca, 'XTickLabel', ''); % set y-axis labels
colors=brewermap(30,'PRGn');
colormap(colors(7:30,:)); % set the colorscheme
colorbar; % enable colorbar

%% Select input for PCA analysis
in=[ MD.TreeHeight MD.DBH MD.TotalVolume MD.PathFraction  MD.AspectRatio MD.CrownArea MD.CrownAsym MD.BranchingAngle  MD.CVR MD.fo1 MD.dom1 ];
labels={'Height', 'dbh','Volume','Path Fraction','Aspect Ratio','Crown Area','Crown Asymmetry','Branching Angle','CVR','fo','dom'};

in=[  MD.TotalVolume MD.PathFraction  MD.AspectRatio MD.CrownArea MD.CrownAsym MD.BranchingAngle  MD.CVR  ];
labels={'Volume','Path Fraction','AspectRatio','CrownArea','CrownAsymmetry','Branching Angle','CVR'};

in=[ MD.TreeHeight log(MD.DBH)  log(MD.TotalVolume) MD.PathFraction MD.AspectRatio log(MD.CrownArea) MD.CrownAsym MD.BranchingAngle  MD.CVR  ];
labels={'H', 'log(dbh)','log(Volume)','Path Fraction', 'AspectRatio','log(CrownArea)','CrownAsymmetry','Branching Angle','CVR'};

%% Normalize and centre the variables
PLOT=0;
in1=nan(size(in));
for col=1:size(in,2)
col
    a=in(:,col);
    a_std=std(a,'omitnan');
    a_mean=mean(a,'omitnan');
    a=(a-a_mean)/a_std;
    in1(:,col)=a;
    if PLOT==1
        subplot(1,2,1)
        hist(in(:,col))
        title(labels{col})
        subplot(1,2,2)
        hist(in1(:,col))
        pause
    end
end

%% PCA analysis and Figure 4
a=6;
fs=9;
temperate_size=10;
tropical_size=15;

[coeff,score,latent,tsquared,explained,mu] = pca(in1);
Xcentered = score*coeff';

h1=scatter(score(UK,1),score(UK,2),20,'+','MarkerEdgeColor',colors1(3,:),'LineWidth',1,'MarkerEdgeAlpha',0.8);
hold on
h2=scatter(score(Australia,1),score(Australia,2),20,'+','MarkerEdgeColor',colors2(1,:),'LineWidth',1.2);
h3=scatter(score(Guyana,1),score(Guyana,2),10,'filled','MarkerFaceColor',dark2(1,:),'MarkerFaceAlpha',1);
h4=scatter(score(Indonesia,1),score(Indonesia,2),10,'filled','MarkerFaceColor',dark2(2,:),'MarkerFaceAlpha',1);
h5=scatter(score(Brazil,1),score(Brazil,2),10,'filled','MarkerFaceColor',dark2(3,:),'MarkerFaceAlpha',1);
h6=scatter(score(Gabon,1),score(Gabon,2),10,'filled','MarkerFaceColor',dark2(4,:),'MarkerFaceAlpha',1);
h7=scatter(score(FrenchG,1),score(FrenchG,2),10,'filled','MarkerFaceColor',dark2(5,:),'MarkerFaceAlpha',1);
h8=scatter(score(Malaysia,1),score(Malaysia,2),10,'filled','MarkerFaceColor',dark2(6,:),'MarkerFaceAlpha',1);
h9=scatter(score(London,1),score(London,2),15,'s','MarkerEdgeColor',dark2(8,:),'LineWidth',1.3);

hold on
for i=1:length(coeff(:,1))
    hold on
    plot(a*cat(1,0,coeff(i,1)),a*cat(1,0,coeff(i,2)),'k')
end
text(a*coeff(1,1)+0.1,a*coeff(1,2),labels{1},'FontWeight', 'bold','FontSize',fs)
text(a*coeff(2,1)+0.1,a*coeff(2,2)+0.2,labels{2},'FontWeight', 'bold','FontSize',fs)
text(a*coeff(3,1)+0.1,a*coeff(3,2),labels{3},'FontWeight', 'bold','FontSize',fs)
text(a*coeff(4,1)-1.5,a*coeff(4,2)-0.4,labels{4},'FontWeight', 'bold','FontSize',fs)
text(a*coeff(5,1),a*coeff(5,2)-0.3,labels{5},'FontWeight', 'bold','FontSize',fs)
text(a*coeff(6,1)+0.1,a*coeff(6,2),labels{6},'FontWeight', 'bold','FontSize',fs)
text(a*coeff(7,1)-3.5,a*coeff(7,2)+0.2,labels{7},'FontWeight', 'bold','FontSize',fs)
text(a*coeff(8,1)-3,a*coeff(8,2)+0.2,labels{8},'FontWeight', 'bold','FontSize',fs)
text(a*coeff(9,1)-0.2,a*coeff(9,2)+0.2,labels{9},'FontWeight', 'bold','FontSize',fs)
box on
h=legend([h1 h2 h3 h4 h7 h8 h6  h5 h9], 'Temperate - UK','Temperate - Australia', 'Tropical - Guyana','Tropical - Indonesia', 'Tropical - French Guiana','Tropical - Malaysia',  'Tropical - Gabon','Tropical - Brazil', 'Open-grown - London','Location','Eastoutside')

axis([-6 12 -3 8])
xticks ''; yticks '';
legend boxoff
set(gca, 'FontName', 'Helvetica','FontSize', 10)
set(h, 'FontName', 'Helvetica','FontSize', 12)

xlabel(strcat('PC1 (',num2str(round(explained(1),1)), '% variation)'),'FontSize',12)
ylabel(strcat('PC2 (',num2str(round(explained(2),1)), '% variation)'),'FontSize',12)
