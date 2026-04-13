% Parameters
int: total_fund = 10000;                 % Total available investment dollars
int: min_invest_X = 2000;                % Minimum investment in opportunity X (whole dollars)
int: min_invest_Y = 3000;                % Minimum investment in opportunity Y (whole dollars)
float: return_rate_X = 0.05;             % Return per dollar invested in X
float: return_rate_Y = 0.08;             % Return per dollar invested in Y

% Variables
var min_invest_X..total_fund: invest_X;  % Dollars invested in X (integer, bounded)
var min_invest_Y..total_fund: invest_Y;  % Dollars invested in Y (integer, bounded)
var 0.0..(return_rate_X * total_fund + return_rate_Y * total_fund): total_return;
                                         % Total return in dollars (bounded float)

% Constraints
% Budget allocation constraint: invest the entire fund across X and Y
constraint
  invest_X + invest_Y = total_fund;

% Total return definition: link total_return to the chosen investments
constraint
  total_return = return_rate_X * int2float(invest_X)
               + return_rate_Y * int2float(invest_Y);

% Objective
solve minimize total_return;