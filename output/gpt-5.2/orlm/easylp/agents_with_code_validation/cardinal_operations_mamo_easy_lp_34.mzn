% Parameters
int: total_fund = 10000;                 % Total amount available to invest (USD)
int: min_invest_X = 2000;                % Minimum investment in opportunity X (USD)
int: min_invest_Y = 3000;                % Minimum investment in opportunity Y (USD)
float: return_rate_X = 0.05;             % Return per dollar invested in X (USD/USD)
float: return_rate_Y = 0.08;             % Return per dollar invested in Y (USD/USD)

% Variables
var min_invest_X..total_fund: invest_X;  % Amount invested in X (whole dollars)
var min_invest_Y..total_fund: invest_Y;  % Amount invested in Y (whole dollars)
var 0.0..(return_rate_X * int2float(total_fund) + return_rate_Y * int2float(total_fund)): total_return; % Total return (USD)

% Constraints
% Budget allocation: total investment must use the entire available fund
constraint invest_X + invest_Y = total_fund;

% Total return calculation: linear combination of investments and return rates
constraint
  total_return = return_rate_X * int2float(invest_X)
               + return_rate_Y * int2float(invest_Y);

% Objective
solve minimize total_return;