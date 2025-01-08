
clear

% Set our mean, variance and standard deviation
mu = 1.5;
var = 1.5^2;
std_dev = sqrt(var);

% Compute the CDF at 0
cdf_0 = normcdf(0, mu, std_dev);

% Compute the pdf and cdf at x = 0
pdf_x0 = normpdf((0-mu)/std_dev);
cdf_x0 = normcdf((0-mu)/std_dev);

% Compute the expected payoff in round 3 using the inverse mills ratio
v_3 = (1-cdf_0) * (mu + std_dev * (pdf_x0/(1-cdf_x0)));


% Compute the pdf and cdf at x = v_3
pdf_xv3 = normpdf((v_3-mu)/std_dev);
cdf_xv3 = normcdf((v_3-mu)/std_dev);

% Compute the expected payoff in round 2 using expected payoff of round 3
% and the inverse mills ratio
v_2 = (v_3 *(1-cdf_xv3)) * (mu + std_dev * (pdf_xv3/(1-cdf_xv3)));

% Compute the pdf and cdf at x = v_2
pdf_xv2 = normpdf((v_2-mu)/std_dev);
cdf_xv2 = normcdf((v_2-mu)/std_dev);

% Compute the expected payoff in round 1 using expected payoff of round 2
% and the inverse mills ratio
v_1 = (v_2 * (1-cdf_xv2)) * (mu + std_dev * (pdf_xv2/(1-cdf_xv2)));

fprintf('Expected payoffs from lottery:\n');
fprintf('Expected payoff from round 3:  %.4f\n', v_3)
fprintf('Expected payoff from round 2:  %.4f\n', v_2)
fprintf('Expected payoff from round 1:  %.4f\n', v_1)

% Set N for number of loops/simulations
N = 1000;

% Initialize one-dimensional array as a (Nx1) matrix of 0s
% to store optimal payoff 
opt_pay = zeros(N, 1);

for i = 1:N
    % Create a (1x3) matrix of normal randomly generated numbers with a 
    % mean of mu and standard deviation of std_dev
    r = normrnd(mu, std_dev, [1, 3]);
    
    % Check if random numbers meet the accept threshold
    if r(1) > v_2
        % Store the first lottery in the opt_pay array if larger then
        % threshold
        opt_pay(i) = r(1);
    else 
        if r(2) > v_3
            % Store the second lottery in the opt_pay array if larger than
            % threshold
            opt_pay(i) = r(2);
        else
            if r(3) >= 0
                % Store the third lottery in the opt_pay array if larger
                % than 0
                opt_pay(i) = r(3);
            else
                % If we dont accept any of the lotteries then we
                % necessarily rejected all therefore store a 0
                opt_pay(i) = 0;
            end
        end
    end
end

% Display the average opt_pay 
disp('Optimal Payoff Average:');
disp(mean(opt_pay));

% Set N_2 for number of loops/simulations of the loops/simulations
N_2 = 500;

% Initialize an empty list/array to store optimal payoff means
opt_pay_mean = []; 

for j = 1:N_2
% Initialize one-dimensional array as a (Nx1) matrix of 0s
% to store optimal payoff 
opt_pay = zeros(N, 1);

    for i = 1:N
        % Create a (1x3) matrix of normal randomly generated numbers with a 
        % mean of mu and standard deviation of std_dev
        r = normrnd(mu, std_dev, [1, 3]);
        
        % Check if random numbers meet the accept threshold
        if r(1) > v_2
            % Store the first lottery in the opt_pay array if larger then
            % threshold
            opt_pay(i) = r(1);
        else 
            if r(2) > v_3
                % Store the second lottery in the opt_pay array if larger than
                % threshold
                opt_pay(i) = r(2);
            else
                if r(3) >= 0
                    % Store the third lottery in the opt_pay array if larger
                    % than 0
                    opt_pay(i) = r(3);
                else
                    % If we dont accept any of the lotteries then we
                    % necessarily rejected all therefore store a 0
                    opt_pay(i) = 0;
                end
            end
        end
    end
    % Calculate and store the mean for the current iteration
    opt_pay_mean(j) = mean(opt_pay);
end

disp('Mean of 500 Optimal payoff averages:');
disp(mean(opt_pay_mean));
disp('Standard deviation of 500 Optimal payoff averages:');
disp(std(opt_pay_mean));

