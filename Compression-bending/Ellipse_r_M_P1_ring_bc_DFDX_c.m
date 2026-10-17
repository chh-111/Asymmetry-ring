function Jbc = Ellipse_r_M_P1_ring_bc_DFDX_c(T, x0, x1, p)
% Boundary-condition Jacobian for the quarter-ring model.
    Jbc = zeros(16,38); 
    % 32,33,34,35,36,37,38 -> p(1),p(2),p(3),p(4),p(5),p(6),p(7)
    % 'Y','pr','h2t','epsilon','c','L','d'
    % 16 boundary equations; 38 columns ordered as T, x0(1:15), x1(1:15), p(1:7).
    Jbc(1,1) = 1;

    Jbc(2,8) = 1;
    Jbc(3,9) = 1;
    Jbc(3,38) = 1;
    Jbc(4,10) = 1;

    Jbc(5,11) = 1;
    Jbc(5,32) = 1/2*sin(p(1)/2);
    Jbc(6,12) = 1;
    Jbc(7,13) = 1;
    Jbc(8,14) = 1;
    Jbc(8,32) = -1/2*cos(p(1)/2);

    Jbc(9,17) = 1;
    Jbc(10,18) = 1;

    Jbc(11,22) = 1;
    Jbc(11,35) = -1/p(6);
    Jbc(11,37) = p(4)./p(6).^2;
    Jbc(12,24) = 1;

    Jbc(13,26) = 1;
    Jbc(13,27) = -1;

    Jbc(14,28) = 1;
    Jbc(14,29) = 1;

    Jbc(15,30) = 1;
    Jbc(15,35) = -1;

    Jbc(16,31) = 1;

end