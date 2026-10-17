function fbc = Ellipse_r_M_P1_ring_bc_c(T, x0, x1, p)
% 'bvp'-compatible boundary conditions for the quarter-ring model.
% F1, F2, F3, k1, k2, k3
% r1, r2, r3, q0, q1, q2, q3, theta, t (state variables x(1) through x(15))
% 'Y','pr','h2t','epsilon','c','L','d'
fbc = [T-pi/2;  %1
    x0(7)-0;  %2
    x0(8)+p(7)-1;  %3
    x0(9)-0;  %4
    x0(10)-cos(p(1)/2);  %5
    x0(11)-0;  %6
    x0(12)-0;  %7
    x0(13)-sin(p(1)/2);  %8
    x1(1)-0;  %9
    x1(2)-0;  %10
    x1(6)-p(4)./p(6);  %11  At this boundary, k3 equals the intrinsic twist k3u
    x1(8)-0;  %12
    x1(10)-x1(11);  %13
    x1(12)+x1(13);%14
    x1(14)-p(4);  %15
    x1(15)-pi/2];  %16
end
