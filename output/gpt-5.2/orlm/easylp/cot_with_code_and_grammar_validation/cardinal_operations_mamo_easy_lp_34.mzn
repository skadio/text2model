% Parameters
int: total_fund = 10000;
int: min_X = 2000;
int: min_Y = 3000;
int: rX_cents_per_dollar = 5;   % 0.05$ = 5 cents per dollar
int: rY_cents_per_dollar = 8;   % 0.08$ = 8 cents per dollar

% Variables
var min_X..total_fund: invest_X;
var min_Y..total_fund: invest_Y;
var 0..(rX_cents_per_dollar*total_fund + rY_cents_per_dollar*total_fund): total_return_cents;

% Constraints
constraint invest_X + invest_Y = total_fund;

constraint total_return_cents =
  rX_cents_per_dollar * invest_X + rY_cents_per_dollar * invest_Y;

% Objective
solve minimize total_return_cents;