function plotringBend(r1,r2,r3,labs_length,idx)
% first color k will never be used, just occupies a position.
colors = 'krgbmkcyrgbmkcyrgbmkcyrgbmkcyrgbmkcyrgbmkcyrgbmkcyrgbmkcy';
colors = linspecer(labs_length,'sequential'); %'sequential','qualitative'
colors = [0,0,0];

    plot3(r2(end),r3(end),r1(end),'k','markersize',4); hold on;
    plot3(r2(end),-r3(end),r1(end),'k','markersize',4); hold on;
    plot3(r2,r3,r1,'Color',colors(1,:),'Linewidth',1.5); hold on;
    plot3(r2,-r3,r1,'Color',colors(1,:),'Linewidth',1.5);
    plot3(2*r2(end)-r2,-r3,r1,'Color',colors(1,:),'Linewidth',1.5);
    plot3(2*r2(end)-r2,r3,r1,'Color',colors(1,:),'Linewidth',1.5);

xlabel('2');ylabel('3');zlabel('1');
axis equal
% zlim([min([0,r1]),2.2]);
grid on;
end