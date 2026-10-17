% function plotRibbon(sol,idx,lengthcolor)
% % for ode_isol2bvp implementation
% 
% colors = tab10(lengthcolor); % autumn(8);
% 
% x = sol.x(:,7); y = sol.x(:,8); z = sol.x(:,9);
% d1x = 2*(sol.x(:,10).^2 + sol.x(:,11).^2 - 0.5);
% d1y = 2*(sol.x(:,11).*sol.x(:,12) + sol.x(:,10).*sol.x(:,13));
% d1z = 2*(sol.x(:,11).*sol.x(:,13) - sol.x(:,10).*sol.x(:,12));
% v = -0.2:0.1:0.2; v=0.4*v;
% 
% x_surf = [x+d1x*v(1), x+d1x*v(2), x+d1x*v(3), x+d1x*v(4), x+d1x*v(5)];
% y_surf = [y+d1y*v(1), y+d1y*v(2), y+d1y*v(3), y+d1y*v(4), y+d1y*v(5)];
% z_surf = [z+d1z*v(1), z+d1z*v(2), z+d1z*v(3), z+d1z*v(4), z+d1z*v(5)];
% 
% % scatter3(y,z,x,'.k');
% 
% surf(y_surf,z_surf,x_surf,'EdgeColor','none','FaceColor',colors(idx,:),'FaceLighting','gouraud','AmbientStrength',0.5);hold on;
% surf(y_surf,-z_surf,x_surf,'EdgeColor','none','FaceColor',colors(idx,:),'FaceLighting','gouraud','AmbientStrength',0.5);hold on;
% surf(-y_surf,-z_surf,x_surf,'EdgeColor','none','FaceColor',colors(idx,:),'FaceLighting','gouraud','AmbientStrength',0.5);hold on;
% surf(-y_surf,z_surf,x_surf,'EdgeColor','none','FaceColor',colors(idx,:),'FaceLighting','gouraud','AmbientStrength',0.5);hold on;
% 
% % dx_dt = gradient(x);
% %%
% % material dull
% material([0.5,0.1,0.01])
% % material([0.5,0.1 ,0.01, 0, 0]) % ambient/diffuse/specular
% %%
% % material metal
% 
% light('Position',[-1 0 0.5],'Style','infinite')
% light('Position',[-1 1 0.5],'Style','infinite')
% light('Position',[-1 -1 0.5],'Style','infinite')
% light('Position',[-20 -0 20],'Style','local')
% 
% axis equal
% 
% 
% end
% 

function plotRibbon(sol,idx,colors,alpha)

% colors = tab20(20);
% colors = 

% Centerline
x = sol.x(:,7); 
y = sol.x(:,8); 
z = sol.x(:,9);

% Quaternion components (q0 q1 q2 q3)
q0 = sol.x(:,10);
q1 = sol.x(:,11);
q2 = sol.x(:,12);
q3 = sol.x(:,13);

% -------- ribbon dimensions ----------
w = 0.05*1.5;   % width  (local width direction)
t = 0.0125*1.5;   % thickness (local thickness direction)
% -------------------------------------

% Unit vectors in the local cross-section frame
ex_local = [1;0;0];  % Width direction
ey_local = [0;1;0];  % Thickness direction

% Convert quaternions to rotation matrices
N = length(x);
ex = zeros(N,3);
ey = zeros(N,3);

for i = 1:N
    q = [q0(i) q1(i) q2(i) q3(i)];

    % quaternion to rotation matrix
    R = quat2rotm(q);

    ex(i,:) = (R * ex_local).';
    ey(i,:) = (R * ey_local).';
end

% Construct the four ribbon edge curves
p = [x y z];

% Corner curves of the rectangular cross-section
p1 = p + ( w/2 )*ex + ( t/2 )*ey;
p2 = p - ( w/2 )*ex + ( t/2 )*ey;
p3 = p - ( w/2 )*ex - ( t/2 )*ey;
p4 = p + ( w/2 )*ex - ( t/2 )*ey;

% Draw the four longitudinal surfaces
faces = {
    p1, p2;   % Top surface
    p2, p3;   % Right surface
    p3, p4;   % Bottom surface
    p4, p1;   % Left surface
};
% 
for k = 1:4
    A = faces{k,1};
    B = faces{k,2};
    surf( ...
        [A(:,2) B(:,2)], ...   % y
        [A(:,3) B(:,3)], ...   % z
        [A(:,1) B(:,1)], ...   % x
        'EdgeColor','none', ...
        'FaceColor',colors(idx,:), ...
        'FaceLighting','gouraud', ...
        'AmbientStrength',0.5,...
        'FaceAlpha',alpha );
    hold on;
end

for k = 1:4
    A = faces{k,1};
    B = faces{k,2};
    surf( ...
        [A(:,2) B(:,2)], ...   % y
        -[A(:,3) B(:,3)], ...   % z
        [A(:,1) B(:,1)], ...   % x
        'EdgeColor','none', ...
        'FaceColor',colors(idx,:), ...
        'FaceLighting','gouraud', ...
        'AmbientStrength',0.5,...
        'FaceAlpha',alpha );
    hold on;
end

for k = 1:4
    A = faces{k,1};
    B = faces{k,2};
    surf( ...
        -[A(:,2) B(:,2)], ...   % y
        [A(:,3) B(:,3)], ...   % z
        [A(:,1) B(:,1)], ...   % x
        'EdgeColor','none', ...
        'FaceColor',colors(idx,:), ...
        'FaceLighting','gouraud', ...
        'AmbientStrength',0.5,...
        'FaceAlpha',alpha );
    hold on;
end

for k = 1:4
    A = faces{k,1};
    B = faces{k,2};
    surf( ...
        -[A(:,2) B(:,2)], ...   % y
        -[A(:,3) B(:,3)], ...   % z
        [A(:,1) B(:,1)], ...   % x
        'EdgeColor','none', ...
        'FaceColor',colors(idx,:), ...
        'FaceLighting','gouraud', ...
        'AmbientStrength',0.5,...
        'FaceAlpha',alpha );
    hold on;
end
% Lighting and material
% Matte finish
% material([0.5,0.1,0.01]) % ambient/diffuse/specular
% 
% light('Position',[-1 0 0.5],'Style','infinite')
% light('Position',[-1 1 0.5],'Style','infinite')
% light('Position',[-1 -1 0.5],'Style','infinite')
% light('Position',[-20 -0 20],'Style','local')


% Ribbon lighting
% material([0.3 0.6 1.0 20 0.5])
% light('Position',[2 2 4],'Style','infinite');      % Key light
% light('Position',[-3 1 2],'Style','infinite');     % Fill light
% light('Position',[0 -4 4],'Style','infinite');     % Rim light
% material metal
% light('Position',[-1 0 0.5],'Style','infinite')
% light('Position',[-1 1 0.5],'Style','infinite')
% light('Position',[-1 -1 0.5],'Style','infinite')
% light('Position',[-20 -0 20],'Style','local')

axis equal
end
