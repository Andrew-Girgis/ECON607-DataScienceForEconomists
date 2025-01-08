% Define some parameters
alpha = 7/10;
p = 3/20;
y = 1;

% Define the utility function
utility = @(x) -(x(1)^alpha * x(2)^(1-alpha));

% Initial guess for the decision variables (x and y)
x0 = [20, 20];  % Initial guess

% Define lower and upper bounds for the decision variables
lb = [0, 0];  % Non-negativity constraints
ub = [];      % No upper bounds

% Create an options structure (optional)
options = optimoptions('fmincon', 'Display', 'iter');

% Define the nonlinear constraint function
nonlcon = @(x) deal([], x(1) + p*x(2) - y); % Budget constraint

% Use fmincon to solve the utility maximization problem
[x, fval, exitflag, output, lambda] = fmincon(utility, x0, [], [], [], [], lb, ub, nonlcon, options);

% Display the results
fprintf('Optimal allocation of goods:\n');
fprintf('Quantity of c: %.4f units\n', x(1));
fprintf('Quantity of h: %.4f units\n', x(2));
fprintf('Optimal utility: %.4f\n', -fval);  % Negative sign due to maximization
