function jm = Jacobian_matrix(estimates,ADPRICE)

% define a small increment for numerical differentiation
epsilon = 1e-6; 

for i = 1:length(estimates)

    % perturb the parameter value
    PARAMS_perturbed = estimates;
    PARAMS_perturbed(i) = PARAMS_perturbed(i) + epsilon;

    % compute the momeents at perturbed parameter values
    moments_perturbed = model_moments(PARAMS_perturbed,ADPRICE);

    % compute the derivative of each moment w.r.t. the parameter using numerical differentiation
    derivative = (moments_perturbed - model_moments(estimates,ADPRICE)) / epsilon;

    % Assign the derivative to the Jacobian matrix
    Jacobian_matrix(:, i) = derivative;

end

jm = Jacobian_matrix;