%% Direction 1: forward loading
clear all;
clc;

% Initialize the bundled COCO toolboxes relative to this main script.
script_dir = fileparts(mfilename('fullpath'));
project_dir = fileparts(script_dir);
coco_dir = fullfile(project_dir, 'coco', 'coco');
assert(isfile(fullfile(coco_dir, 'core', 'toolbox', 'coco.m')), ...
    'Bundled COCO was not found at %s.', coco_dir);
addpath(script_dir);

% Load the bundled palette functions and their accompanying MAT data.
addpath(fullfile(project_dir, 'slanCL'), fullfile(project_dir, 'slanCM'));

addpath(fullfile(coco_dir, 'core', 'toolbox'), ...
    fullfile(coco_dir, 'covering', 'toolbox'), ...
    fullfile(coco_dir, 'ep', 'toolbox'), ...
    fullfile(coco_dir, 'coll', 'toolbox'), ...
    fullfile(coco_dir, 'po', 'toolbox'), ...
    fullfile(coco_dir, 'recipes'), ...
    fullfile(coco_dir, 'continex', 'toolbox'), ...
    fullfile(coco_dir, 'contributed', 'symcoco', 'toolbox'));

coco_use_recipes_toolbox coll_v1 bvp_v1 % add the coll_v1 and bvp_v1 toolboxes to the search path
angle_list = [0, pi/6, pi/3, pi/2, pi/2*1.2];
h2t_list = [2,4,6];
%1.1
for idx = 2:length(h2t_list)
    h2t = h2t_list(idx);
    %     for i = 3:length(angle_list)
    for i = 3:3
        epsilon = angle_list(i);
        % Initialize the ring
        c = 0.8;  % b/a
        a=1; b=a*c;
        e = sqrt(1-(b/a)^2);
        L = a*ellipticE(e^2);  % One quarter of the ellipse perimeter
        runName_r = sprintf('Ellipse_r_P1_h2t%d_c%d_%d',h2t,c,epsilon);
        t0 = [0; pi/2];
        x0 = [0,0,0, 1/c^2,0,epsilon/L, 0,1,0, 1,0,0,0, 0, 0;
            0,0,0, c*cos(epsilon),-c*sin(epsilon),epsilon/L, 0,0,c, 1/sqrt(2)*cos(epsilon/2), 1/sqrt(2)*cos(epsilon/2), ...
            -1/sqrt(2)*sin(epsilon/2), 1/sqrt(2)*sin(epsilon/2), epsilon,pi/2 ];
        % F1, F2, F3, k1, k2, k3
        % r1, r2, r3, q0, q1, q2, q3, theta, t
        % Set up the continuation problem
        Y0 = 0; % p(1), angle
        d = 0;  % p(7), Distance
        coll_args = {@Ellipse_r_M_P1_ring_c, t0, x0, {'Y','pr','h2t','epsilon','c','L','d'}, [Y0; 0.3;h2t; epsilon; c; L;d]};
        bvp_args  = [coll_args, {@Ellipse_r_M_P1_ring_bc_c, @Ellipse_r_M_P1_ring_bc_DFDX_c}];
        prob      = bvp_isol2seg(coco_prob(), '', bvp_args{:});
        prob = coco_set(prob, 'cont', 'NAdapt', 10, 'ItMX', 2000, 'NPR',0.2);
        prob = coco_set(prob, 'corr', 'LogLevel',0);
        bd1 = coco(prob, runName_r, [], 1, {'d'},[0 a]);


        runName_r_M = sprintf('Ellipse_r_M_P1_h2t%d_c%d_%d',h2t,c,epsilon);
        labs_r = coco_bd_labs(bd1);
        sol_r = bvp_read_solution('', runName_r, labs_r(end));


        prob      = bvp_isol2seg(coco_prob(), '', bvp_args{:});
        %         prob = coco_set(prob, 'cont', 'NAdapt', 10, 'ItMX', 2000, 'NPR',0.2);
        %         prob = coco_set(prob, 'corr', 'LogLevel',0);
        %         prob = coco_set(prob,'cont','h',0.0628,'h_max', 0.0628, 'NAdapt',10);
        prob = bvp_sol2seg(coco_prob(),'',runName_r,labs_r(end));
        prob = coco_set(prob, 'cont', 'NAdapt', 10, 'ItMX', 2000, 'NPR',1);
        bd2 = coco(prob, runName_r_M, [], 1, {'Y'},[0 2*pi]);
    end
end

%% Read results: ring configurations or moment-angle curves
% close all;clear all;clc;
coco_use_recipes_toolbox coll_v1 bvp_v1 % add the coll_v1 and bvp_v1 toolboxes to the search path
Color_arry = tab20c(20);
line_type = {'-','--',':'};
angle_name=[0,30,60,90];
angle_list = [0, pi/6, pi/3, pi/2, pi/2*1.2];
h2t_list = [2,4,6];

idx=2;i=3;c=0.8;
h2t = h2t_list(idx);
epsilon = angle_list(i);

R= 100;
t = 1;
h = h2t*t;
I1 = 1/12*h*t^3; I2 = 1/12*t*h^3; E=2000;
J=J_cal(h,t);
pr = 0.3;
GJ = E.*1./(2.*(1.+pr))*J;

a=1;b=a*c;
e = sqrt(1-(b/a)^2);
L = a*ellipticE(e^2);  % One quarter of the ellipse perimeter
k3u = angle_list(i)/L;

runName_r_M = sprintf('Ellipse_r_M_P1_h2t%d_c%d_%d',h2t,c,epsilon);
plotflag = 1; % 1: ring configurations; otherwise: moment-angle curve
bd2 = coco_bd_read(runName_r_M); % Extract bifurcation data
labs = coco_bd_labs(bd2); % Extract solution labels
labs = labs(:).';

if plotflag == 1
    for lab = labs
        figure;
        labs_length = length(labs);
        idp = ceil((lab-1)/2+1);
        sol = bvp_read_solution('', runName_r_M, lab); % Extract solution
        plotringBend(sol.x(:,7),sol.x(:,8),sol.x(:,9),labs_length,idp);
        legend(sprintf('Y=%.1f,Ellip-h/t%d-ε=%.2f-lab=%d',sol.p(1)/pi*180,h2t, angle_list(i),lab),'Location','best','FontSize',20)
        set(gca,'FontName','Times New Roman','FontSize',20,'LineWidth',2,'FontWeight','bold');
        xlim([-1.5,1.5]);
        ylim([-1.5,1.5]);
        zlim([-1,1]);
        %                 grid off;
        %                 set(gcf, 'Color', 'none');   % Transparent figure background
    end
else
    figure
    k3u = angle_list(i)/L;
    Yer = zeros(numel(labs),1);
    K2bar = zeros(numel(labs),1);
    for j = 1:numel(labs)
        lab = labs(j);
        sol = bvp_read_solution('', runName_r_M, lab); % Extract solution
        Yer(j) = sol.p(1); % Loading angle (rad)
        K2bar(j) = sol.x(1,6)-k3u; % Subtract the intrinsic twist k3u
    end
    M2bar = 2*K2bar;
    plot(Yer/pi*180,-M2bar,'Color',Color_arry(4*(i-1)+1,:),'LineStyle',line_type{1},'Linewidth',2,'DisplayName', sprintf('Ellip-h/t%d-c%d-ε-= %.2f',h2t,c,angle_list(i))); hold on;
    %             xlabel('Angle(rad)'); ylabel('M2bar');
    save([runName_r_M '_response.mat'],'Yer','M2bar');
    xlabel('Loading angle (deg)');
    ylabel('-M2bar');
end

hold on;
% ylim([-8,8]);
% xlim([0,360]);
% legend('show','Location','best','FontSize',20,'Box','off');

% xticks([0,100,200,300,360]);
% grid on;
grid off;
set(gca,'GridAlpha',1,'FontName','Times New Roman','FontSize',20,'LineWidth',2,'FontWeight','bold');



%% Extract y1 versus loading angle
% Use the same run and parameter case as in the response extraction above.
% y1 is the gripper-tip out-of-plane displacement: sol.x(end,7).
% Coordinates are normalized by the reference length a = 1.
bd2 = coco_bd_read(runName_r_M);
labs = coco_bd_labs(bd2);
Yer = zeros(numel(labs),1);
y1 = zeros(numel(labs),1);
for j = 1:numel(labs)
    lab = labs(j);
    sol = bvp_read_solution('', runName_r_M, lab);
    Yer(j) = sol.p(1); % Loading angle (rad)
    y1(j) = sol.x(end,7); % Signed displacement; preserve the loading direction
end
figure;
plot(Yer/pi*180,y1,'Color',Color_arry(4*(i-1)+1,:), ...
    'LineStyle',line_type{1},'LineWidth',2, ...
    'DisplayName',sprintf('h/t=%g, c=%g, epsilon=%.2f',h2t,c,angle_list(i)));
xlabel('Loading angle (deg)');
ylabel('y_1/a');
legend('show','Location','best','FontSize',20,'Box','off');
set(gca,'FontName','Times New Roman','FontSize',20,'LineWidth',2,'FontWeight','bold');
save([runName_r_M '_y1_angle.mat'],'Yer','y1');



%%  Figure: plot ribbon
coco_use_recipes_toolbox coll_v1 bvp_v1 % add the coll_v1 and bvp_v1 toolboxes to the search path
Color_arry = tab20c(20);
angle_list = [0, pi/6, pi/3, pi/2, pi/2*1.2];
h2t_list = [2,4,6];
line_type = {'-','--',':'};
angle_name=[0,30,60,90];

plotflag = 1; % Retained from the response section; ribbon rendering below is unconditional
idx = 2; i = 3; c = 0.8; % h/t = 4, epsilon = 60 degrees, c = 0.8
h2t = h2t_list(idx);
epsilon = angle_list(i);
runName_r_M = sprintf('Ellipse_r_M_P1_h2t%d_c%d_%d',h2t,c,epsilon);
bd1 = coco_bd_read(runName_r_M); % Extract bifurcation data
bd = coco_bd_read(runName_r_M);



%%  Select configurations for forward loading
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% turning-back segment for h/t = 4, epsilon = 60 degrees, c = 0.8: labels 121 (96.3 deg) to 371 (96.1 deg)


% Palette dependencies: slanCL (and slanCM if optional gradients are enabled).
% savepath

figure

idp = 3;
colors = slanCL(25);

Yq_for = [0:pi/6:pi];

% ===== Set label intervals to exclude during angle-based sampling =====
lab_exclude = [
    121, 371
]; %%% Interval identified from the computed response curve

% ===== Select labels closest to the target loading angles outside the excluded intervals =====
plot_lab_for = coco_get_labs_at_Y_exclude(bd, Yq_for, lab_exclude);

% Include any additional manually selected labels if required
plot_lab_for = unique([plot_lab_for, lab_exclude(:).'], 'stable');


plot_lab_0 = plot_lab_for;



%%  Render configurations for forward loading
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
figure

idp = 3;colors = slanCL(25);


plot_lab_0 = plot_lab_for;  

angle_0 = [];
for lab = plot_lab_for
    %         figure;
    labs_length = length(plot_lab_for);
    % idp=5;
    sol = bvp_read_solution('', runName_r_M, lab); % Extract solution
    sol.x(:,8) = sol.x(:,8)+2;
    % sol.x(:,)
    % colors = slanCL(25);
    % ===== Select the ribbon opacity =====
    if ismember(lab, plot_lab_0)
        alpha_use = 1;    % Fully opaque selected configuration
        angle_0 = [angle_0,sol.p(1)/pi*180];
    else
        alpha_use = 0;    % Fully transparent unselected configuration
    end
    plotRibbon(sol, idp, colors, alpha_use);
    legend(sprintf('Y=%.1f,h/t%d-ε=%.2f-lab=%d',sol.p(1)/pi*180,h2t, angle_list(i),lab),'Location','best','FontSize',20)
    grid off;
    axis off;
    fprintf('Loading angle: %.2f deg\n', sol.p(1)/pi*180);
    %         xlabel('x');ylabel('y');zlabel('z');
end

%%   Tip trajectories and markers: forward loading
% ===== Collect the gripper-tip trajectory =====
labs = coco_bd_labs(bd);


% Trajectory segments for h/t = 4, epsilon = 60 degrees, c = 0.8
plot_lab_for_l1 = [1:4:121];
plot_lab_for_l2 = [371:2:478];
plot_lab_for_l3 = [121:2:371];



traj = []; % Each row stores [x y z] in the solution coordinate system
Yer = [];
%%%%%%%%%%%%%%%%%%%% Collect the pre-snap trajectory segment
for lab = plot_lab_for_l1
    sol = bvp_read_solution('', runName_r_M, lab); % Extract solution
    xt = sol.x(end,7);
    yt = sol.x(end,8);
    zt = sol.x(end,9);
    Yer = [Yer;sol.p(1)];
    traj = [traj; xt yt zt];
end
% ===== Plot the gripper-tip trajectory =====
if size(traj,1) > 1
    plot3( ...
        traj(:,2)-3.5, traj(:,3), traj(:,1), ... % Display coordinate order: (y,z,x)
        'Color',[0,0,0], ...
        'LineWidth', 2 ); hold on;
end
%%%%%%%%%%%%%%%%%%%% Collect the post-snap trajectory segment
traj = []; % Each row stores [x y z] in the solution coordinate system
Yer = [];
for lab = plot_lab_for_l2
    sol = bvp_read_solution('', runName_r_M, lab); % Extract solution
    xt = sol.x(end,7);
    yt = sol.x(end,8);
    zt = sol.x(end,9);
    Yer = [Yer;sol.p(1)];
    traj = [traj; xt yt zt];
end
% ===== Plot the gripper-tip trajectory =====
if size(traj,1) > 1
    plot3( ...
        traj(:,2)-3.5, traj(:,3), traj(:,1), ... % Display coordinate order: (y,z,x)
        'Color',[0,0,0], ...
        'LineWidth', 2 ); hold on;
end

%%%%%%%%%%%%%%%%%%%% Collect the intervening snap-through branch
traj = []; % Each row stores [x y z] in the solution coordinate system
Yer = [];
for lab = plot_lab_for_l3
    sol = bvp_read_solution('', runName_r_M, lab); % Extract solution
    xt = sol.x(end,7);
    yt = sol.x(end,8);
    zt = sol.x(end,9);
    Yer = [Yer;sol.p(1)];
    traj = [traj; xt yt zt];
end
% ===== Plot the gripper-tip trajectory =====
if size(traj,1) > 1
    plot3( ...
        traj(:,2)-3.5, traj(:,3), traj(:,1), ... % Display coordinate order: (y,z,x)
        'Color',[0,0,0], ...
        'LineWidth', 2 ,...
        'LineStyle','--'); hold on;
end



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
colors1 = slanCL(1661);
colors2 = slanCL(1664);
colors_for = colors1(1:5,:);
colors_back = colors2(7:11,:);

colors1 = slanCL(527);
colors2 = slanCL(530);
colors_for = colors1(2:8,:);
% colors_for = flipud(colors_for);
n_for = length(plot_lab_for);
colors_for = interpomap(n_for,colors_for);

colors_back = colors2(2:8,:);
colors_back = flipud(colors_back);
% colors_back = flipud(colors_back);
% n_back = length(plot_lab_back);
% colors_back = interpomap(n_back,colors_back);


colors_p = [colors_for];

% N = length(Yq_p);
% colors_p = interpomap(N,colors_p);

plot_lab_p = [plot_lab_for];

% =========Plot colored tip markers=========
for idp = 1:length(plot_lab_p)
    lab = plot_lab_p(idp);
    labs_length = length(plot_lab_p);
    %         idp = idp+1;
    % idp=5;
    sol = bvp_read_solution('', runName_r_M, lab); % Extract solution

    % colors = slanCL(97);
    last_p = round(size(sol.x,1));   % Final node of the quarter-ring solution (gripper tip)
    xt = sol.x(last_p,7);
    yt = sol.x(last_p,8);
    zt = sol.x(last_p,9);

    scatter3( ...
        yt-3.5, zt, xt, ...    % (y,z,x)
        80, ...           % Marker size
        'filled', ...
        'MarkerFaceColor',colors_p(idp,:), ...
        'MarkerEdgeColor','w', ...
        'LineWidth',1.5);
    scatter3(0,0,0,40,'filled','k');


    % text( yt, zt, xt, ...             % Use the same (y,z,x) coordinate order as the ribbon surfaces
    %     sprintf('Y = %.2f°,%d', sol.p(1)/pi*180,lab), ...
    %     'FontSize',14, ...
    %     'FontName','Times New Roman', ...
    %     'FontWeight','bold', ...
    %     'Color',[1 0 0]);

end

angle_0_rad = angle_0/180*pi;
% set(gca, 'SortMethod', 'childorder');
drawnow;
axis on;
xlabel({'x'});ylabel({'y'});zlabel({'z'});


angle_0_rad = angle_0/180*pi;
step = angle_0_rad / 6.28;
% set(gca, 'SortMethod', 'childorder');
drawnow;
box on;
ylim([-2,2]);
zlim([-1,1]);
axis equal;
set(gca,'GridAlpha',1,'FontName','Arial','FontSize',18,'LineWidth',1.5);
material([0.3 0.6 0.3 5 0]);
light('Position',[-4 0 0],'Style','infinite');     % Rim light
view(-90,0);
% view(-90,0);

% axis off;set(gcf,'Color','w');set(gcf,'InvertHardcopy','off');print(gcf, 'c10-0du-1.png', '-dpng', '-r1200');
% axis off;set(gcf,'Color','w');set(gcf,'InvertHardcopy','off');print(gcf, 'c07-60du-5.png', '-dpng', '-r1200');
% axis off;set(gcf,'Color','w');set(gcf,'InvertHardcopy','off');print(gcf, 'SI-H2T6-c08-60du-1-Forward.png', '-dpng', '-r1200');

% axis off;set(gcf,'Color','w');set(gcf,'InvertHardcopy','off');print(gcf, 'c10-0du-3.png', '-dpng', '-r1200');
axis off;set(gcf,'Color','w');set(gcf,'InvertHardcopy','off');print(gcf, 'h2t4-c08-60du-1.png', '-dpng', '-r1200');
% 
% axis off;print(gcf, 'c10-0du-2.eps', '-depsc2', '-r600');
% axis off;print(gcf, 'c10-0du-1.png', '-dpng', '-r1200');
% axis off;print(gcf, 'c10-0du-3.png', '-dpng', '-r1200');



% ========= colormap strip for points =========
N = size(colors_p,1);   % Number of colors, matching the tip markers

figure('Color','w','Position',[200 200 600 120]);
hold on;

x = 1:N;
y = zeros(1,N);

scatter( ...
    x, y, ...
    120, ...                     % Marker size for the color strip
    colors_p, ...                % One color per marker
    'filled', ...
    'MarkerEdgeColor','w', ...
    'LineWidth',1.2 );

axis equal;
axis off;
xlim([0.5, N+0.5]);
ylim([-0.6, 0.6]);

set(gca,'FontName','Arial','FontSize',14,'LineWidth',1);

% axis off;set(gcf,'Color','w');set(gcf,'InvertHardcopy','off');print(gcf, 'colormap_0duc10_2.png', '-dpng', '-r1200');
% axis off;print(gcf, 'colormap_0duc10_2.eps', '-depsc2', '-r600');
% axis off;set(gcf,'Color','w');set(gcf,'InvertHardcopy','off');print(gcf, 'colormap_60duc07.png', '-dpng', '-r1200');
% axis off;print(gcf, 'colormap_60duc07.eps', '-depsc2', '-r600');






%%  Select configurations for reverse loading
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

figure

idp = 5;colors = slanCL(97);


Yq_back = [pi:pi/6:2*pi];

% ===== Set label intervals to exclude during angle-based sampling =====
lab_exclude = [
    2, 3
];  % Retain the original placeholder exclusion [2,3] for reverse loading; no reverse turning-back segment is specified

% ===== Select labels closest to the target loading angles outside the excluded intervals =====
plot_lab_back = coco_get_labs_at_Y_exclude(bd, Yq_back, lab_exclude);

% Include any additional manually selected labels if required
plot_lab_back = unique([plot_lab_back], 'stable');

plot_lab_0 = plot_lab_back;



%% Render configurations for reverse loading
figure
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
idp = 5;colors = slanCL(97);
    labs = coco_bd_labs(bd);

angle_0 = [];
for lab = plot_lab_back
    %         figure;
    labs_length = length(plot_lab_back);
    sol = bvp_read_solution('', runName_r_M, lab); % Extract solution
    % ===== Select the ribbon opacity =====
    if ismember(lab, plot_lab_0)
        alpha_use = 1;    % Fully opaque selected configuration
        angle_0 = [angle_0,sol.p(1)/pi*180];
    else
        alpha_use = 0;    % Fully transparent unselected configuration
    end
    plotRibbon(sol, idp, colors, alpha_use);

    legend(sprintf('Y=%.1f,h/t%d-ε=%.2f-lab=%d',sol.p(1)/pi*180,h2t, angle_list(i),lab),'Location','best','FontSize',20)
    % grid off;
    % axis off;
    fprintf('Loading angle: %.2f deg\n', sol.p(1)/pi*180);
    %         xlabel('x');ylabel('y');zlabel('z');
end

%%   Tip trajectories and markers: reverse loading
% ===== Collect the gripper-tip trajectory =====
labs = coco_bd_labs(bd);

%  Trajectory segments for h/t = 4, epsilon = 60 degrees, c = 0.8
plot_lab_back_l1 = [478:1:721];
plot_lab_back_l2 = [];



traj = []; % Each row stores [x y z] in the solution coordinate system
Yer = [];
%%%%%%%%%%%%%%%%%%%% Collect the pre-snap trajectory segment
for lab = plot_lab_back_l1
    sol = bvp_read_solution('', runName_r_M, lab); % Extract solution
    xt = sol.x(end,7);
    yt = sol.x(end,8);
    zt = sol.x(end,9);
    Yer = [Yer;sol.p(1)];
    traj = [traj; xt yt zt];
end
% ===== Plot the gripper-tip trajectory =====
if size(traj,1) > 1
    plot3( ...
        traj(:,2)-3.5, traj(:,3), traj(:,1), ... % Display coordinate order: (y,z,x)
        'Color',[0,0,0], ...
        'LineWidth', 2 ); hold on;
end
%%%%%%%%%%%%%%%%%%%% Collect the post-snap trajectory segment
traj = []; % Each row stores [x y z] in the solution coordinate system
Yer = [];
for lab = plot_lab_back_l2
    sol = bvp_read_solution('', runName_r_M, lab); % Extract solution
    xt = sol.x(end,7);
    yt = sol.x(end,8);
    zt = sol.x(end,9);
    Yer = [Yer;sol.p(1)];
    traj = [traj; xt yt zt];
end
% ===== Plot the gripper-tip trajectory =====
if size(traj,1) > 1
    plot3( ...
        traj(:,2)-3.5, traj(:,3), traj(:,1), ... % Display coordinate order: (y,z,x)
        'Color',[0,0,0], ...
        'LineWidth', 2 ); hold on;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
colors1 = slanCL(1661);
colors2 = slanCL(1664);
colors_for = colors1(1:5,:);
colors_back = colors2(7:11,:);

colors1 = slanCL(527);
colors2 = slanCL(530);
colors_for = colors1(2:8,:);
% colors_for = flipud(colors_for);
% n_for = length(plot_lab_for);
% colors_for = interpomap(n_for,colors_for);

colors_back = colors2(2:8,:);
colors_back = flipud(colors_back);
% colors_back = flipud(colors_back);
n_back = length(plot_lab_back);
colors_back = interpomap(n_back,colors_back);

colors_p = [colors_back];

% N = length(Yq_p);
% colors_p = interpomap(N,colors_p);

plot_lab_p = [plot_lab_back];

% =========Plot colored tip markers=========
for idp = 1:length(plot_lab_p)
    lab = plot_lab_p(idp);
    labs_length = length(plot_lab_p);
    %         idp = idp+1;
    % idp=5;
    sol = bvp_read_solution('', runName_r_M, lab); % Extract solution

    % colors = slanCL(97);
    last_p = round(size(sol.x,1));   % Final node of the quarter-ring solution (gripper tip)
    xt = sol.x(last_p,7);
    yt = sol.x(last_p,8);
    zt = sol.x(last_p,9);

    scatter3( ...
        yt-3.5, zt, xt, ...    % (y,z,x)
        80, ...           % Marker size
        'filled', ...
        'MarkerFaceColor',colors_p(idp,:), ...
        'MarkerEdgeColor','w', ...
        'LineWidth',1.5);
    scatter3(0,0,0,40,'filled','k');


%     text( yt, zt, xt, ...             % Use the same (y,z,x) coordinate order as the ribbon surfaces
%         sprintf('Y = %.2f°,%d', sol.p(1)/pi*180,lab), ...
%         'FontSize',14, ...
%         'FontName','Times New Roman', ...
%         'FontWeight','bold', ...
%         'Color',[1 0 0]); 3b

end

angle_0_rad = angle_0/180*pi;
% set(gca, 'SortMethod', 'childorder');
drawnow;
axis on;
xlabel({'x'});ylabel({'y'});zlabel({'z'});

angle_0_rad = angle_0/180*pi;
step = angle_0_rad / 6.28;
% set(gca, 'SortMethod', 'childorder');
drawnow;
box on;
ylim([-3,3]);
zlim([-1.5,1.5]);
axis equal;
set(gca,'GridAlpha',1,'FontName','Arial','FontSize',18,'LineWidth',1.5);
material([0.3 0.6 0.3 5 0]);
light('Position',[-4 0 0],'Style','infinite');     % Rim light
view(-90,0);




% ========= colormap strip for points =========
N = size(colors_p,1);   % Number of colors, matching the tip markers

figure('Color','w','Position',[200 200 600 120]);
hold on;

x = 1:N;
y = zeros(1,N);

scatter( ...
    x, y, ...
    120, ...                     % Marker size for the color strip
    colors_p, ...                % One color per marker
    'filled', ...
    'MarkerEdgeColor','w', ...
    'LineWidth',1.2 );

axis equal;
axis off;
xlim([0.5, N+0.5]);
ylim([-0.6, 0.6]);

set(gca,'FontName','Arial','FontSize',14,'LineWidth',1);

% axis off;set(gcf,'Color','w');set(gcf,'InvertHardcopy','off');print(gcf, 'colormap_0duc10.png', '-dpng', '-r1200');
% axis off;print(gcf, 'colormap_0duc10.eps', '-depsc2', '-r600');
% axis off;set(gcf,'Color','w');set(gcf,'InvertHardcopy','off');print(gcf, 'colormap_60duc07_reverse.png', '-dpng', '-r1200');
% axis off;print(gcf, 'colormap_60duc07_reverse.eps', '-depsc2', '-r600');


%% ====== Plot the colors_p color strip and marker outlines ======
figure('Color','w','Units','pixels','Position',[100 100 1400 120]); % Wide figure for the color strip
y0 = 0.5 * ones(size(x));

scatter(x, y0, 100, colors_p, 'filled', ...          % 30 -> 10
    'MarkerEdgeColor','w', 'LineWidth',1);  % Marker edge width
axis off
xlim([min(x) max(x)])
ylim([0 1])

print(gcf, 'color_p_6.png', '-dpng', '-r1200');
print(gcf, 'color_p_6.eps', '-depsc', '-r600');


N = length(x);          % Number of outline markers, matching the color-strip points

colors = slanCL(527);   % Palette used for the outline markers
Color_arry = colors( ...
    round(linspace(60, 220, N)), :);

hold on;
for k = 1:N
    scatter( ...
        x(k), y(k), ...
        200, ...                     % Outline marker size
        'o', ...
        'MarkerFaceColor','none', ... % Unfilled marker
        'MarkerEdgeColor', Color_arry(k,:), ...
        'LineWidth', 2);
end
set(gcf,'Color','w');
set(gca,'FontName','Arial','FontSize',16,'LineWidth',1);
box on;



