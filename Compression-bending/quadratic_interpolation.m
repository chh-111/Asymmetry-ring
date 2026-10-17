function y = quadratic_interpolation(a, b)
    % Select the segment containing b
    if b <= a/2
        % First segment: (0, 0), (a/4, 1), (a/2, 0)
        x1 = 0;
        y1 = 0;
        x2 = a/4;
        y2 = 1;
        x3 = a/2;
        y3 = 0;
    else
        % Second segment: (a/2, 0), (3a/4, 1), (a, 0)
        x1 = a/2;
        y1 = 0;
        x2 = 3*a/4;
        y2 = 1;
        x3 = a;
        y3 = 0;
    end

    % Fit y = A*x^2 + B*x + C through three points
    % Construct the linear system
    A = [x1^2, x1, 1;
         x2^2, x2, 1;
         x3^2, x3, 1];
    
    B = [y1; y2; y3];
    
    % Solve for the coefficients
    coeffs = A \ B;
    
    % Extract the quadratic coefficients
    A = coeffs(1);
    B = coeffs(2);
    C = coeffs(3);

    % Evaluate the quadratic at b
    y = A * b^2 + B * b + C;
end

