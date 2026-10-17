function plotringBend(r1,r2,r3,labs_length,idx)
% first color k will never be used, just occupies a position.
colors = 'krgbmkcyrgbmkcyrgbmkcyrgbmkcyrgbmkcyrgbmkcyrgbmkcyrgbmkcy';
colors = linspecer(labs_length,'sequential'); %'sequential','qualitative'
colors = tab20(20);

if idx ==0
    plot3(r2(end),r3(end),r1(end),'ok','markersize',4); hold on;
    plot3(r2(end),-r3(end),r1(end),'ok','markersize',4); hold on;
    plot3(r2,r3,r1,'--','Color',[0.5,0.5,0.5],'Linewidth',1);
    plot3(r2,-r3,r1,'--','Color',[0.5,0.5,0.5],'Linewidth',1);
    plot3(2*r2(end)-r2,-r3,r1,'--','Color',[0.5,0.5,0.5],'Linewidth',1);
    plot3(2*r2(end)-r2,r3,r1,'--','Color',[0.5,0.5,0.5],'Linewidth',1);
else
    plot3(r2,r3,r1,'Color',colors(1,:),'Linewidth',6); hold on;
    plot3(r2,-r3,r1,'Color',colors(1,:),'Linewidth',6);
    plot3(2*r2(end)-r2,-r3,r1,'Color',colors(1,:),'Linewidth',6);
    plot3(2*r2(end)-r2,r3,r1,'Color',colors(1,:),'Linewidth',6);
    % plot3(r2(end),r3(end),r1(end),'ok','markersize',10,'LineWidth',1); hold on;
    % plot3(r2(end),-r3(end),r1(end),'ok','markersize',10,'LineWidth',1); hold on;
end

xlabel('2');ylabel('3');zlabel('1');
axis equal
% zlim([min([0,r1]),2.2]);
grid on;
end