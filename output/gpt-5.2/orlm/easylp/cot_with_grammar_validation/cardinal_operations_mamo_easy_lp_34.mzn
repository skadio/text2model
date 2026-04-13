% Parameters
int: total_fund = 10000;
int: min_x = 2000;
int: min_y = 3000;
int: return_x_cents = 5;   % 0.05 dollars = 5 cents per dollar
int: return_y_cents = 8;   % 0.08 dollars = 8 cents per dollar

% Variables
var min_x..total_fund: invest_x;
var min_y..total_fund: invest_y;
var 0..(total_fund * max(return_x_cents, return_y_cents)): total_return_cents;

% Constraints
constraint invest_x + invest_y = total_fund;

constraint total_return_cents =
  return_x_cents * invest_x + return_y_cents * invest_y;

% Objective
solve minimize total_return_cents;