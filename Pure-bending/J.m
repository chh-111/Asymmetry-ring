h = 2; % Adjust this value as needed
t = 0.5; % Adjust this value as needed
N = 2000; % Truncation limit (number of series terms)
% Initialize the series sum
sum_term = 0;
% Approximate the infinite series by a finite sum
for n = 1:N
    term = 1 / (2*n - 1)^5 * tanh(pi * (2*n - 1) * h / (2 * t));
    sum_term = sum_term + term;
end
% Compute the torsional constant J
J_value = (h * t^3) / 3 * (1 - (192 / pi^5) * (t / h) * sum_term);
% Display the result
disp(['J = ', num2str(J_value)]);