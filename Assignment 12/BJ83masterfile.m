clear

%%%%%%%%%%%%%%%%%%%%%%%%%%
% create vectors of data %
%%%%%%%%%%%%%%%%%%%%%%%%%%

% a vector of advertised prices for a Breville Cafe Roma Espresso Machine
ADPRICE = sort([223.99; 279.99; 199.99; 199.99; 224.99; 279.99; 209.99; 279.99; 243.10; 249.98; 299.99; 305.21; 314.99; 329.40; 403.56]);

N = length(ADPRICE);

%%%%%%%%%%%%%%%%%%%%%%%%%%
% plot the empirical CDF %
%%%%%%%%%%%%%%%%%%%%%%%%%%

% generate the empirical CDF of advertised prices
ADECDF = ecdf(ADPRICE);

F1 = figure(1);
stairs([0; unique(ADPRICE)],ADECDF);
lines = get(gca,'children');
set(lines,'LineWidth',2)
set(gca,'fontsize',18)
xlabel({'posted price (CAD)'},'FontSize',18)
ylabel({'CDF'},'FontSize',18)
xlim([180 420]);

% determine the quartiles of the empirical price distribution
ep25 = ADPRICE(round((N+1)/4));
ep50 = ADPRICE(round((N+1)/2));
ep75 = ADPRICE(round(3*(N+1)/4));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Parameter Estimation of the Burdett-Judd model %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% define the objective function (squared differences between model quartiles and empirical quartiles)
objective_function = @(estimates) sum((model_moments(estimates,ADPRICE) - [ep25 ep50 ep75]).^2);

% initial guess
estimates0 = [10 10 1/2]; 

% minimize the objective function using fmincon
options = optimoptions('fmincon','Display','iter'); % Display optimization progress
estimates = fmincon(objective_function, estimates0, [], [], [], [], [0 0 0], [Inf Inf 1], [], options);

q = estimates(3);

%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Compute Standard Errors %
%%%%%%%%%%%%%%%%%%%%%%%%%%%

% compute the Jacobian matrix at the estimated values
Jacobian = Jacobian_matrix(estimates,ADPRICE);

% calculate the variance-covariance matrix
residuals = model_moments(estimates,ADPRICE) - [ep25 ep50 ep75];
variance_covariance_matrix = 1 / length(residuals) * inv(Jacobian' * Jacobian);

% extract the standard errors (square root of diagonal elements of variance-covariance matrix)
standard_errors = sqrt(diag(variance_covariance_matrix));

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Recover Structural Parameters from Estimates %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

parameters = GfunPARAMS(estimates,ADPRICE);
pSTAR = parameters(1);
r = parameters(2);
c = parameters(3);

% Display results
fprintf('estimate of buyers max willingness to pay, pSTAR: %.4f\n', pSTAR);
fprintf('estimate of sellers marginal cost, r: %.4f\n', r);
fprintf('estimate of buyers search cost, c: %.4f\n', c);

% compute the Jacobian matrix for Gfun with respect to estimates
J_Gfun = Jacobian_Gfun(estimates,ADPRICE);

% compute the estimated variance of the function Gfun(PARAMS) using the delta method
variance_G = J_Gfun * variance_covariance_matrix * J_Gfun';

% Display the estimated standard errors 
fprintf('standard error of pSTAR: %.4f\n', sqrt(variance_G(1,1)));
fprintf('standard error of r: %.4f\n', sqrt(variance_G(2,2)));
fprintf('standard error of c: %.4f\n', sqrt(variance_G(3,3)));

%%%%%%%%%%%%%%%%%%%%%
% Display Model Fit %
%%%%%%%%%%%%%%%%%%%%%

% plot the CDF implied by the theory
pLBAR = 2 * (1 - q) / (2 - q) * r + q / (2 - q) * pSTAR;
pSTEP = (pSTAR-pLBAR)/100;
for p = pLBAR:pSTEP:pSTAR
    
    pGRID(round((p-pLBAR)/pSTEP)+1,1) = p;
    FGRID(round((p-pLBAR)/pSTEP)+1,1) = 1 - (1/2) * (q / (1 - q)) * ((pSTAR - p) / (p - r));
    
end

F2 = figure(2);
stairs([0; unique(ADPRICE)],ADECDF); hold on
plot([0; pGRID], [0; FGRID])
lines = get(gca,'children');
set(lines,'LineWidth',2)
set(gca,'fontsize',18)
xlabel({'posted price (CAD)'},'FontSize',18)
ylabel({'CDF'},'FontSize',18)
xlim([180 420]);
ylim([0 1]);

