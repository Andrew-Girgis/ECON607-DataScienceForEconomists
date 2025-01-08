function jG = Jacobian_funG(estimates,ADPRICE)

% define a small increment for numerical differentiation
epsilon = 1e-6; 

for i = 1:length(estimates)

    % perturb the parameter value
    estimates_perturbed = estimates;
    estimates_perturbed(i) = estimates_perturbed(i) + epsilon;

    % compute the momeents at perturbed parameter values
    parameters_perturbed = Gfun(estimates_perturbed,ADPRICE);

    % compute the derivative of each moment w.r.t. the parameter using numerical differentiation
    derivative = (parameters_perturbed - Gfun(estimates,ADPRICE)) / epsilon;

    % Assign the derivative to the Jacobian matrix
    Jacobian_matrix(:, i) = derivative;

end

jG = Jacobian_matrix;