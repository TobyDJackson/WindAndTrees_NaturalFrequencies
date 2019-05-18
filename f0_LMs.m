% This script is part of Jackson et al 2019  'An architectural understanding of natural sway frequencies in trees'
% It calculates linear models for the fundamental frequency based on Abaqus model outputs

%%   Import data and set up definitions
Import_Summary_Model_Data

MD(MD.TotalVolume>=100,:)=[];  MD(MD.CVR>=20,:)=[]; % Remove 2 outliers
MD(find(isnan(MD.fo1)==1),:)=[]; % Remove failed simulations (collapsed under gravity)

% optional exclude large open grown trees (results in parenthesis in table 1)
%MD(strcmp(MD.Location,'London')==1 & MD.fo>0.4,:)=[]; 
%MD(strcmp(MD.Location,'London')==1 & MD.Beam>2.2e-3,:)=[];  

colors= brewermap(10,'PuOr');
colors1= brewermap(8,'Accent');
colors2=brewermap(12,'Paired');

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


%% Add variables one by one for figure S1
tbl=MD;
robust='off';
lm1=fitlm(tbl,'fo1~Beam','RobustOpts',robust); 
lm2=fitlm(tbl,'fo1~Beam+Beam:(CVR)','RobustOpts',robust); 
lm3=fitlm(tbl,'fo1~Beam+Beam:(CVR+CrownAsym)','RobustOpts',robust); 
lm4=fitlm(tbl,'fo1~Beam+Beam:(CVR+CrownAsym+AspectRatio)','RobustOpts',robust); 
lm5=fitlm(tbl,'fo1~Beam+Beam:(CVR+CrownAsym+AspectRatio+CrownArea)','RobustOpts',robust); 
lm6=fitlm(tbl,'fo1~Beam+Beam:(CVR+CrownAsym+AspectRatio+CrownArea+BranchingAngle)','RobustOpts',robust); 
lm7=fitlm(tbl,'fo1~Beam+Beam:(CVR+CrownAsym+AspectRatio+CrownArea+BranchingAngle+PathFraction)','RobustOpts',robust); 
lm8=fitlm(tbl,'fo1~Beam+Beam:(CVR+CrownAsym+AspectRatio+CrownArea+BranchingAngle+PathFraction+TotalVolume)','RobustOpts',robust); 
mult_R2=cat(1,lm1.Rsquared.Adjusted,lm2.Rsquared.Adjusted,lm3.Rsquared.Adjusted,lm4.Rsquared.Adjusted,...
lm5.Rsquared.Adjusted,lm6.Rsquared.Adjusted,lm7.Rsquared.Adjusted,lm8.Rsquared.Adjusted)
mult_AIC=cat(1,lm1.ModelCriterion.AIC,lm2.ModelCriterion.AIC,lm3.ModelCriterion.AIC,lm4.ModelCriterion.AIC,...
        lm5.ModelCriterion.AIC,lm6.ModelCriterion.AIC,lm7.ModelCriterion.AIC,lm8.ModelCriterion.AIC);

lm1=fitlm(tbl,'fo1~Beam','RobustOpts',robust); 
lm2=fitlm(tbl,'fo1~Beam+(CVR)','RobustOpts',robust); 
lm3=fitlm(tbl,'fo1~Beam+(CVR+CrownAsym)','RobustOpts',robust); 
lm4=fitlm(tbl,'fo1~Beam+(CVR+CrownAsym+AspectRatio)','RobustOpts',robust); 
lm5=fitlm(tbl,'fo1~Beam+(CVR+CrownAsym+AspectRatio+CrownArea)','RobustOpts',robust); 
lm6=fitlm(tbl,'fo1~Beam+(CVR+CrownAsym+AspectRatio+CrownArea+BranchingAngle)','RobustOpts',robust); 
lm7=fitlm(tbl,'fo1~Beam+(CVR+CrownAsym+AspectRatio+CrownArea+BranchingAngle+PathFraction)','RobustOpts',robust); 
lm8=fitlm(tbl,'fo1~Beam+(CVR+CrownAsym+AspectRatio+CrownArea+BranchingAngle+PathFraction+TotalVolume)','RobustOpts',robust); 
add_R2=cat(1,lm1.Rsquared.Adjusted,lm2.Rsquared.Adjusted,lm3.Rsquared.Adjusted,lm4.Rsquared.Adjusted,...
lm5.Rsquared.Adjusted,lm6.Rsquared.Adjusted,lm7.Rsquared.Adjusted,lm8.Rsquared.Adjusted)
add_AIC=cat(1,lm1.ModelCriterion.AIC,lm2.ModelCriterion.AIC,lm3.ModelCriterion.AIC,lm4.ModelCriterion.AIC,...
        lm5.ModelCriterion.AIC,lm6.ModelCriterion.AIC,lm7.ModelCriterion.AIC,lm8.ModelCriterion.AIC);

 %Make the plot adding 1 variable at a time for SI
labels={ '','dbh / H^2','CVR','Crown Asymmetry','Aspect Ratio', 'Crown Area','Branching Angle','Path Fraction','Total Volume'};
subplot(2,1,1)
scatter(1:8,mult_R2,40,'+','MarkerEdgeColor',colors1(7,:),'LineWidth',2)
hold on
scatter(1:8,add_R2,40,'+','MarkerEdgeColor',colors1(2,:),'LineWidth',2)
scatter(1,add_R2(1),40,'+','MarkerEdgeColor','black','LineWidth',2)
axis([0 9 0.32 1.02])
hleg=legend('Multiplicative model','Additive model','Cantilever beam approximation','Location','SouthEast'); legend boxoff; 
%xticklabels(labels); xtickangle(45)
xticklabels ''
ylabel('R^2'); % ylabel('Pearsons correlation coefficient (R^2)')
set([gca hleg], 'FontName', 'Helvetica','FontSize', 10)
title('Linear models for {\itf_0} - all trees')
%
subplot(2,1,2)
scatter(1:8,mult_AIC,40,'+','MarkerEdgeColor',colors1(7,:),'LineWidth',2)
hold on
scatter(1:8,add_AIC,40,'+','MarkerEdgeColor',colors1(2,:),'LineWidth',2)
scatter(1,add_AIC(1),40,'+','MarkerEdgeColor','black','LineWidth',2)
axis([0 9 -2500 -600])
%hleg=legend('Multiplicative model','Additive model','Location','NorthEast'); legend boxoff;
xticks(0:8); xticklabels(labels); xtickangle(45)
ylabel('AIC'); %ylabel('Akaike information criterion')
set([gca hleg], 'FontName', 'Helvetica','FontSize', 10)


%% Plot each model and effect size for SI
modelspec='fo1~Beam';
%modelspec='fo1~Beam+Beam:(CVR+CrownAsym+AspectRatio)';
%modelspec='fo1~Beam+CVR+CrownAsym+AspectRatio';
robust='bisquare';
%robust='off';
for i=1:4
    if i==1; tbl=MD;                          title_text='All trees ';  end
    if i==2; tbl=MD(temperate,:);    title_text='Temperate '; end
    if i==3; tbl=MD(tropical,:);       title_text='Tropical ';   end
    if i==4; tbl=MD(London,:);         title_text='Open-grown ';    end
   
    lm1=fitlm(tbl,modelspec,'RobustOpts',robust); 
    subplot(2,4,i)
    h=plot(lm1);
    legend off
    title([title_text '\itf_0 (N=' num2str(lm1.NumObservations)  ',  R^2=' num2str(round(lm1.Rsquared.Adjusted,2))  ')'],'Interpreter','Tex','FontSize',3)
    set(gca, 'FontName', 'Helvetica','FontSize', 8)
    subplot(2,4,i+4)
    %h=plotEffects(lm1);
    h=plotResiduals(lm1);
        jbtest(lm1.Residuals.Raw)
    pause
    title([title_text '\itf_0 (N=' num2str(lm1.NumObservations)  ',  R^2=' num2str(round(lm1.Rsquared.Adjusted,2))  ')'],'Interpreter','Tex','FontSize',3)
    xlabel('Effect size')
    %set(h,'Marker','+','MarkerSize',2,'Color','black','LineWidth',1)
    if i==1
        set(gca,'YtickLabel',{'dbh/H^2','CVR','Crown Asymmetry','Aspect Ratio'})
        xlim([-2 2])
    else
        set(gca,'YtickLabel','')
        xlim([-0.5 0.5])
    end
    if i==3; xlim([-0.5 0.5]); end
    %title([title_text '\itf_o  (R^2=' num2str(round(lmfo.Rsquared.Adjusted,2))  ')'])
    set(gca, 'FontName', 'Helvetica','FontSize', 8)
end


