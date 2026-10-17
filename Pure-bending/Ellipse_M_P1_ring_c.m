function y = Ellipse_M_P1_ring_c(x, p)
% 'coll'-compatible encoding of vector field
% F1, F2, F3, k1, k2, k3
% r1, r2, r3, q0, q1, q2, q3, theta, t
% 'Y','pr','h2t','epsilon','c','L'
pr = p(2,:); % Poisson's ratio
h2t = p(3,1); % h/t
c = p(5,:);  % b/a
L = p(6,:); % One quarter of the ellipse perimeter

t=1;h=t*h2t;

I1 = 1/12*h*t^3; I2 = 1/12*t*h^3; E=2000;
% GJ = (1/3/2)./(1+pr).*(1-(192/pi^5)./h2t.*(tanh(pi*h2t/2)+1/3^5*tanh(3*pi*h2t/2)...
%     +1/5^5*tanh(5*pi*h2t/2))); % for rectangular cross-section
J=J_cal(h,t);
GJ = E.*1./(2.*(1.+pr))*J; 
a = E.*I1./GJ; b = E.*I2./GJ; % dimensionless parameters


x1 = x(1,:);  %State variable: F1  
x2 = x(2,:);  %State variable: F2  
x3 = x(3,:);  %State variable: F3  
x4 = x(4,:);  %State variable: k1  
x5 = x(5,:);  %State variable: k2  
x6 = x(6,:);  %State variable: k3  
x7 = x(7,:);  %State variable: r1  
x8 = x(8,:);  %State variable: r2  
x9 = x(9,:);  %State variable: r3  
x10 = x(10,:);  %State variable: q0  
x11 = x(11,:);  %State variable: q1  
x12 = x(12,:);  %State variable: q2  
x13 = x(13,:);  %State variable: q3  
x14 = x(14,:);  %theta: inclination angle of the cross-section 
x15 = x(15,:);  %t: ellipse parameter at this cross-section, ranging from 0 to pi/2 

coef = sqrt( (sin(x15)).^2 + c.^2.* (cos(x15)).^2 );

k1u =  c./(coef.^3).*cos(x14);
k2u = -c./(coef.^3).*sin(x14);
k3u = p(4)./L;

k1udt = -c.*3.*(1-c.^2).*sin(x15).*cos(x15).*cos(x14)./(coef.^5)-c./(coef.^3).*sin(x14).*p(4).*coef./L;
k2udt =  c.*3.*(1-c.^2).*sin(x15).*cos(x15).*sin(x14)./(coef.^5)-c./(coef.^3).*cos(x14).*p(4).*coef./L;
k3udt = 0;


y(1,:) = (x2.*x6 - x3.*x5).*coef;
y(2,:) = (x3.*x4 - x1.*x6).*coef;
y(3,:) = (x1.*x5 - x2.*x4).*coef;

y(4,:) = k1udt + (1./a.*x2 + (b./a-1./a).*x5.*x6 - b./a.*x6.*k2u + 1./a.*x5.*k3u).*coef;
y(5,:) = k2udt + (-1./b.*x1 + (1./b-a./b).*x4.*x6 + a./b.*x6.*k1u - 1./b.*x4.*k3u).*coef;
y(6,:) = 0 + ((a-b).*x4.*x5 - a.*x5.*k1u + b.*x4.*k2u).*coef;

y(7,:) = 2*(x11.*x13 + x10.*x12).*coef;
y(8,:) = 2*(x12.*x13 - x10.*x11).*coef;
y(9,:) = 2*(x10.^2 + x13.^2 - 1/2).*coef;

y(10,:) = 1/2*(-x11.*x4 - x12.*x5 - x13.*x6).*coef;
y(11,:) = 1/2*(x10.*x4 - x13.*x5 + x12.*x6).*coef;
y(12,:) = 1/2*(x13.*x4 + x10.*x5 - x11.*x6).*coef;
y(13,:) = 1/2*(-x12.*x4 + x11.*x5 + x10.*x6).*coef;

y(14,:) = p(4).*coef./L;  %Derivative of theta
y(15,:) = 1;  %Derivative of t

% y(4,:) = 1./a.*x2 + (b./a-1./a).*x5.*x6;
% y(5,:) = -1./b.*x1 - (a./b-1./b).*x4.*x6 + a./b.*phi.*x6;
% y(6,:) = (a-b).*x4.*x5 - a.*phi.*x5;
end