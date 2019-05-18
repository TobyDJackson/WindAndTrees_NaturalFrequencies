% This script is part of Jackson et al 2019  'An architectural understanding of natural sway frequencies in trees'
% It calculates linear models for the dominance of the fundamental mode based on Abaqus model outputs

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


%% Add variables one by one for figure S3
tbl=MD;
lm0=fitlm(tbl,'dom1~TreeHeight','RobustOpts',robust); 
lm1=fitlm(tbl,'dom1~TreeHeight+DBH','RobustOpts',robust); 
lm2=fitlm(tbl,'dom1~TreeHeight+DBH+(TotalVolume)','RobustOpts',robust); 
lm3=fitlm(tbl,'dom1~TreeHeight+DBH+(TotalVolume+CrownArea)','RobustOpts',robust); 
lm4=fitlm(tbl,'dom1~TreeHeight+DBH+(TotalVolume+CrownArea+PathFraction)','RobustOpts',robust); 
lm5=fitlm(tbl,'dom1~TreeHeight+DBH+(TotalVolume+CrownArea+PathFraction+CVR)','RobustOpts',robust); 
lm6=fitlm(tbl,'dom1~TreeHeight+DBH+(TotalVolume+CrownArea+PathFraction+CVR+BranchingAngle)','RobustOpts',robust); 
lm7=fitlm(tbl,'dom1~TreeHeight+DBH+(TotalVolume+CrownArea+PathFraction+CVR+BranchingAngle+CrownAsym)','RobustOpts',robust); 
lm8=fitlm(tbl,'dom1~TreeHeight+DBH+(TotalVolume+CrownArea+PathFraction+CVR+BranchingAngle+CrownAsym+AspectRatio)','RobustOpts',robust); 
add_R2=cat(1,lm0.Rsquared.Adjusted,lm1.Rsquared.Adjusted,lm2.Rsquared.Adjusted,lm3.Rsquared.Adjusted,...
lm4.Rsquared.Adjusted,lm5.Rsquared.Adjusted,lm6.Rsquared.Adjusted,lm7.Rsquared.Adjusted,lm8.Rsquared.Adjusted)
add_AIC=cat(1,lm0.ModelCriterion.AIC,lm1.ModelCriterion.AIC,lm2.ModelCriterion.AIC,lm3.ModelCriterion.AIC,...
       lm4.ModelCriterion.AIC, lm5.ModelCriterion.AIC,lm6.ModelCriterion.AIC,lm7.ModelCriterion.AIC,lm8.ModelCriterion.AIC);
   
labels={'Height','DBH','Total Volume','Crown Area','Path Fraction','CVR','Branching Angle','Crown Asymmetry','Aspect Ratio'};
subplot(2,1,1)
scatter(1:9,add_R2,40,'+','MarkerEdgeColor','black','LineWidth',2)
axis([0 10 0 0.5]); xticklabels ''; ylabel('R^2'); 
set([gca], 'FontName', 'Helvetica','FontSize', 10)
title('Linear models for {\itD_0} - all trees')
%
subplot(2,1,2)
scatter(1:9,add_AIC,40,'+','MarkerEdgeColor','black','LineWidth',2)
axis([0 10 -2630 -2310]); xticks(1:9); xticklabels(labels); xtickangle(45); ylabel('AIC'); 
set([gca], 'FontName', 'Helvetica','FontSize', 10)


%% LMs for table 1
robust='off';
tbl=MD;
modelspec='dom~TreeHeight*DBH';
lm_beam=fitlm(tbl,modelspec,'RobustOpts',robust);
plot(lm_beam)
modelspec='dom~TreeHeight*DBH+TotalVolume+PathFraction+CVR';
lm_add3=fitlm(tbl,modelspec,'RobustOpts',robust);
modelspec='dom~TreeHeight*DBH+TreeHeight*DBH:(TotalVolume+PathFraction+CVR)';
lm_mult3=fitlm(tbl,modelspec,'RobustOpts',robust);
modelspec='dom~TreeHeight*DBH*(TotalVolume+PathFraction+CVR)';
lm_addmult3=fitlm(tbl,modelspec,'RobustOpts',robust);
modelspec='dom~TreeHeight*DBH+CVR+CrownAsym+AspectRatio+PathFraction+BranchingAngle+TotalVolume';
lm_add6=fitlm(tbl,modelspec,'RobustOpts',robust);
modelspec='dom~TreeHeight*DBH+TreeHeight*DBH:(CVR+CrownAsym+AspectRatio+PathFraction+BranchingAngle+TotalVolume)';
lm_mult6=fitlm(tbl,modelspec,'RobustOpts',robust);


out=[ lm_beam.Rsquared.Adjusted lm_beam.ModelCriterion.AIC; 
           lm_add3.Rsquared.Adjusted lm_add3.ModelCriterion.AIC;
           lm_mult3.Rsquared.Adjusted lm_mult3.ModelCriterion.AIC;
           lm_add6.Rsquared.Adjusted lm_add6.ModelCriterion.AIC;
           lm_mult6.Rsquared.Adjusted lm_mult6.ModelCriterion.AIC;]
       

%% 6 panel plot of linear models and effect sizes for SI
modelspec='dom1~TreeHeight';
modelspec='dom1~TreeHeight+DBH';
modelspec='dom1~TreeHeight+DBH+TotalVolume+CrownArea';
robust='off';
for i=1:4
    if i==1; tbl=MD;                          title_text='All trees ';  end
    if i==2; tbl=MD(temperate,:);    title_text='Temperate '; end
    if i==3; tbl=MD(tropical,:);       title_text='Tropical ';   end
    if i==4; tbl=MD(London,:);         title_text='Open-Grown ';    end
   
    lm1=fitlm(tbl,modelspec,'RobustOpts',robust); 
    subplot(2,4,i)
    h=plot(lm1);
    legend off
    title([title_text '\itD_0 (N=' num2str(lm1.NumObservations)  ',  R^2=' num2str(round(lm1.Rsquared.Adjusted,2))  ')'],'Interpreter','Tex','FontSize',3)
    set(gca, 'FontName', 'Helvetica','FontSize', 8)
    subplot(2,4,i+4)
    h=plotEffects(lm1);
    title([title_text '\itD_0 (N=' num2str(lm1.NumObservations)  ',  R^2=' num2str(round(lm1.Rsquared.Adjusted,2))  ')'],'Interpreter','Tex','FontSize',3)
    xlabel('Effect size')
    set(h,'Marker','+','MarkerSize',2,'Color','black','LineWidth',1)
    xlim([-1.25 1.25])
    if i==1
        set(gca,'YtickLabel',{'Height','DBH','Total Volume','Crown Area'})
    else
        set(gca,'YtickLabel','')
    end
    %title([title_text '\itf_o  (R^2=' num2str(round(lmfo.Rsquared.Adjusted,2))  ')'])
    set(gca, 'FontName', 'Helvetica','FontSize', 8)
end


