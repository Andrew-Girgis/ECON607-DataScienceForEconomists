% Define some parameters

s = 1;
% Where s is the fixed measure of participating sellers
u = 1;
%Where u is the the buyers utility from consuming the good
c = 1/6;
%Where c is the sellers cost
v_b = 5/54;
%Where u_b is a constraint, value to a buyer of not participating
%(i.e., their outside option)

%

%x = [b, p]

% Define the utility function
utility = @(x) -(x(1)^alpha * x(2)^(1-alpha));

% Initial guess for the decision variables (x and y)
x0 = [14, 1/2];  % Initial guess
%The initial guess can be any *reasonable* guess at what the decision
%variables could be within the bounds

% Define lower and upper bounds for the decision variables
lb = [0, c];  % Non-negativity constraints
ub = [inf, u];      % upper bound of b is infinity 


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
