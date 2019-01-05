    
%% Summer-winter plot
load('y_winter.mat')
load('time_winter.mat')
load('y_summer.mat')
load('time_summer.mat')

amp=3.4E-4; exp1=-0.092; angfreq=1.8; offset=3.31; damp=exp1/angfreq;
yfit_winter=(amp).*exp(exp1.*time_winter).*sin(angfreq.*time_winter+offset);
envelope_winter=(amp).*exp(exp1.*time_winter);

amp=4.2E-4; exp1=-0.17; angfreq=1.4; offset=-0.61; damp=exp1/angfreq;
yfit_summer=(amp).*exp(exp1.*time_summer).*sin(angfreq.*time_summer+offset);
envelope_wsummer=(amp).*exp(exp1.*time_summer);

h1=plot(time_winter(1:end-20),smooth(y_winter(1:end-20),5)+3e-5)  
hold on
h2=plot(time_summer,smooth(y_summer,5))  
h3=refline(0,0)
color1=winter(10);
color2=summer(10);
set(h1, 'LineStyle', '-', 'LineWidth', 2,'Color', color1(4,:))
set(h2, 'LineStyle', '-', 'LineWidth', 2,'Color', color2(4,:))
set(h3, 'LineStyle', ':', 'LineWidth', 1.5,'Color', [0 0 0])
box off
hLegend=legend('Winter', 'Summer', 'Neutral axis', 'Location', 'NorthEast')
legend boxoff
xlabel('Time (s)')
ylabel('Strain (dimensionless)')
set(gca, 'FontName', 'Helvetica')
set([hLegend, gca], 'FontSize', 12)

