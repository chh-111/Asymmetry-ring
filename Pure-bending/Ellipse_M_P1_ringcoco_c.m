%% Direction1 Forward loading
clear all;
clc;

addpath(genpath(fullfile(pwd, 'coco')));
addpath(genpath(fullfile(pwd, 'slanCL')));
coco_use_recipes_toolbox coll_v1 bvp_v1 % Add the coll_v1 and bvp_v1 toolboxes to the search path
angle_list = [0, pi/6, pi/3, pi/2, pi/2*1.2];
h2t_list = [2,4,6,1];

idx = 3;i = 3;
h2t = h2t_list(idx);

epsilon = angle_list(i);
a=1; b=0.8;  % b=1 or b=0.8
c = b/a;  % b/a
e = sqrt(1-(b/a)^2);
L = a*ellipticE(e^2);
runName = sprintf('Ellipse_M_P1_h2t%d_c%d_%d',h2t,c,epsilon);
t0 = [0; pi/2];
x0 = [0,0,0, 1/c^2,0,epsilon/L, 0,1,0, 1,0,0,0, 0, 0;
    0,0,0, c*cos(epsilon),-c*sin(epsilon),epsilon/L, 0,0,c, 1/sqrt(2)*cos(epsilon/2), 1/sqrt(2)*cos(epsilon/2), ...
    -1/sqrt(2)*sin(epsilon/2), 1/sqrt(2)*sin(epsilon/2), epsilon,pi/2 ];
% F1, F2, F3, k1, k2, k3
% r1, r2, r3, q0, q1, q2, q3, theta, t
Y0 = 0; % p(1), angle
coll_args = {@Ellipse_M_P1_ring_c, t0, x0, {'Y','pr','h2t','epsilon','c','L'}, [Y0; 0.3;h2t; epsilon; c; L]};
bvp_args  = [coll_args, {@Ellipse_M_P1_ring_bc_c, @Ellipse_M_P1_ring_bc_DFDX_c}];
prob      = bvp_isol2seg(coco_prob(), '', bvp_args{:});

prob = coco_set(prob, 'cont', 'NAdapt', 10, 'ItMX', 2000, 'NPR',0.2);
prob = coco_set(prob, 'corr', 'LogLevel',0);
prob = coco_set(prob,'cont','h',0.0628,'h_max', 0.0628, 'h_min', 0.0628, 'NAdapt',10);

bd1 = coco(prob, runName, [], 1, {'Y'},[0 2*pi]);

%% Read results: ring configurations or moment-angle curves
clear all;
clc;

addpath(genpath(fullfile(pwd, 'coco')));
addpath(genpath(fullfile(pwd, 'slanCL')));

coco_use_recipes_toolbox coll_v1 bvp_v1 % Add the coll_v1 and bvp_v1 toolboxes to the search path
angle_list = [0, pi/6, pi/3, pi/2, pi/2*1.2];
h2t_list = [2,4,6,1];

Color_arry = tab20c(20);
line_type = {'-','--',':'};
angle_name=[0,30,60,90];

idx = 3;i=3;c=0.8;
h2t = h2t_list(idx);

R= 100;
t = 1;
h = h2t*t;
I1 = 1/12*h*t^3; I2 = 1/12*t*h^3; E=2000;
J=J_cal(h,t);
pr = 0.3;
GJ = E.*1./(2.*(1.+pr))*J;

a=1;b=a*c;
e = sqrt(1-(b/a)^2);
L = a*ellipticE(e^2);

k3u = angle_list(i)/L;
runName = sprintf('Ellipse_M_P1_h2t%d_c%d_%d',h2t,c,angle_list(i));
plotflag = 1; % 1: ring configurations; otherwise: moment-angle curve
bd1 = coco_bd_read(runName); % Extract bifurcation data
labs = coco_bd_labs(bd1); % Extract solution labels
labs = labs(:).';

if plotflag == 1
    % Select available labels; edit this list to display other states.
    shape_labs = labs(unique([1:20:numel(labs), numel(labs)]));
    labs_length = numel(shape_labs);
    for lab = shape_labs
        figure;
        idp = ceil((lab-1)/2+1);
        sol = bvp_read_solution('', runName, lab); % Extract solution
        plotringBend(sol.x(:,7),sol.x(:,8),sol.x(:,9),labs_length,idp);
        legend(sprintf('Y=%.1f,Ellip-h/t%d-ε=%.2f-lab=%d',sol.p(1)/pi*180,h2t, angle_list(i),lab),'Location','best','FontSize',20)
        set(gca,'FontName','Times New Roman','FontSize',20,'LineWidth',2,'FontWeight','bold');
        xlim([-1.4,1.4]);
        ylim([-1.4,1.4]);
        zlim([-1,1]);
        axis off;
        grid off;
    end
else
    figure;
    Yer = zeros(numel(labs),1);
    K2bar = zeros(numel(labs),1);
    for j = 1:numel(labs)
        lab = labs(j);
        sol = bvp_read_solution('', runName, lab); % Extract solution
        Yer(j) = sol.p(1); % Loading angle (rad)
        K2bar(j) = sol.x(1,6)-k3u; % Excess twist at the loaded end
    end
    M2bar = 2*K2bar;
    plot(Yer/pi*180,-M2bar,'Color',Color_arry(4*(i-1)+1,:),'LineStyle',line_type{1},'Linewidth',2,'DisplayName', sprintf('Ellip-h/t%d-ε = %.2f',h2t, angle_list(i))); hold on;

    save([runName '_response.mat'],'Yer','M2bar');
end
hold on;

if plotflag ~= 1
    ylim([-4,6]);
    xlim([0,360]);
    xticks([0,100,200,300,360]);
    xlabel('Loading angle (deg)');
    ylabel('-M2bar');
    legend('show','Location','best','FontSize',20,'Box','off');
    set(gca,'GridAlpha',1,'FontName','Times New Roman','FontSize',20,'LineWidth',2,'FontWeight','bold');
end

%% Extract y1 versus loading angle
% y1 is the gripper-tip out-of-plane displacement: sol.x(end,7).
% Coordinates are normalized by the reference length a = 1.
figure;
idx = 3; i = 3;c = 0.8;
h2t = h2t_list(idx);
runName = sprintf('Ellipse_M_P1_h2t%d_c%d_%d',h2t,c,angle_list(i));
bd1 = coco_bd_read(runName);
labs = coco_bd_labs(bd1);
Yer = zeros(numel(labs),1);
y1 = zeros(numel(labs),1);
for j = 1:numel(labs)
    lab = labs(j);
    sol = bvp_read_solution('', runName, lab);
    Yer(j) = sol.p(1); % Loading angle (rad)
    y1(j) = sol.x(end,7); % Signed displacement; preserve the loading direction
end
plot(Yer/pi*180,y1,'Color',Color_arry(4*(i-1)+1,:), ...
    'LineStyle',line_type{1},'LineWidth',2, ...
    'DisplayName',sprintf('h/t=%g, c=%g, epsilon=%.2f',h2t,c,angle_list(i)));
hold on;
save([runName '_y1_angle.mat'],'Yer','y1');

xlabel('Loading angle (deg)');
ylabel('y_1/a');
legend('show','Location','best','FontSize',20,'Box','off');
set(gca,'FontName','Times New Roman','FontSize',20,'LineWidth',2,'FontWeight','bold');

%% Figure: plot ribbon
coco_use_recipes_toolbox coll_v1 bvp_v1 % add the coll_v1 and bvp_v1 toolboxes to the search path
Color_arry = tab20c(20);
angle_list = [0, pi/6, pi/3, pi/2, pi/2*1.2];
h2t_list = [2,4,6];
line_type = {'-','--',':'};
angle_name=[0,30,60,90];

plotflag = 1; % Retained from the response section; ribbon rendering below is unconditional
idx = 3; i = 3; c = 0.8;
h2t = h2t_list(idx);

runName = sprintf('Ellipse_M_P1_h2t%d_c%d_%d',h2t,c,angle_list(i));
bd1 = coco_bd_read(runName); % Extract bifurcation data
bd = coco_bd_read(runName);
figure

idp = 0;
Yq = [0:0.0628*3:2*pi,2*pi];          % Uniform spacing in loading angle (rad)
plot_lab = coco_get_labs_at_Y(bd, Yq);
plot_lab_0 = [627,840,925];   % Selected fully opaque states for the 60-degree twisted c = 0.8 ring (Fig. 1)
plot_lab = [plot_lab, plot_lab_0, plot_lab(end)]; % Append selected states and redraw the final state
idc = 0;

% Pre-scan the selected states for the moment-based color range
a=1;b=a*c;
e = sqrt(1-(b/a)^2);
L = a*ellipticE(e^2);  % One quarter of the ellipse perimeter
k3u = angle_list(i)/L;

M2bar_all = zeros(numel(plot_lab),1);
for ii = 1:numel(plot_lab)
    sol_tmp = bvp_read_solution('', runName, plot_lab(ii));
    M2bar_all(ii) = -(sol_tmp.x(1,6)-k3u);   % Negative excess twist used for optional color mapping
end
M2bar_min = min(M2bar_all);
M2bar_max = max(M2bar_all);

for lab = plot_lab
    labs_length = length(plot_lab);
    idc = idc+1;
    sol = bvp_read_solution('', runName, lab); % Extract solution

    colors = slanCL(84);  idp = 1;

    % Select the ribbon opacity
    if ismember(lab, plot_lab_0)
        alpha_use = 1;    % Fully opaque selected configuration
        idp = 1;
    elseif lab == 1
        alpha_use = 0.1;    % Faint initial configuration
        idp = 1;
    else
        % Uniform ribbon color
        alpha_use = 0.05;    % Faint background configuration
        idp = 1;
    end
    plotRibbon(sol, idp, colors, alpha_use);

    last_p = round(size(sol.x,1));   % Final node of the quarter-ring solution (gripper tip)
    xt = sol.x(last_p,7);
    yt = sol.x(last_p,8);
    zt = sol.x(last_p,9);

    legend(sprintf('Y=%.1f,h/t%d-ε=%.2f-lab=%d',sol.p(1)/pi*180,h2t, angle_list(i),lab),'Location','best','FontSize',20)
    grid off;
    axis off;
    fprintf('Loading angle: %.2f deg\n', sol.p(1)/pi*180);
    view(-90,0);
end
axis on;
xlabel({'x'});ylabel({'y'});zlabel({'z'});
ax = gca;
XL = xlim(ax);
YL = ylim(ax);
ZL = zlim(ax);

material([0.3 0.6 0.3 5 0]);
light('Position',[-4 0 0],'Style','infinite');     % Rim light
light('Style','local','Position',[-6 0 4]*3);
