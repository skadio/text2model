% Parameters (with values embedded)
int: total_fund = 10000;
int: min_invest_X = 2000;
int: min_invest_Y = 3000;
float: return_rate_X = 0.05;
float: return_rate_Y = 0.08;

% Variables
var min_invest_X..total_fund: invest_X;  % whole dollars invested in X
var min_invest_Y..total_fund: invest_Y;  % whole dollars invested in Y
var float: total_return;

% Constraints
constraint invest_X + invest_Y = total_fund;

constraint total_return =
  return_rate_X * int2float(invest_X) + return_rate_Y * int2float(invest_Y);

% Objective
solve minimize total_return;