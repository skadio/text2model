% Parameters
% Minimum investment requirements (in dollars)
int: min_invest_X = 5000;
int: min_invest_Y = 2000;

% Maximum total investment (in dollars)
int: max_total_invest = 10000;

% Interest rates (as decimals)
float: rate_X = 0.07;
float: rate_Y = 0.08;

% Minimum required interest income (in dollars)
float: min_interest_income = 700.0;

% Transaction cost per dollar invested
float: cost_per_dollar_X = 0.01;
float: cost_per_dollar_Y = 0.02;

% Variables
% Investment amounts (integer dollars)
var min_invest_X..max_total_invest: invest_X;
var min_invest_Y..max_total_invest: invest_Y;

% Total transaction cost (in dollars)
var 0.0..(cost_per_dollar_X * int2float(max_total_invest)
        + cost_per_dollar_Y * int2float(max_total_invest)): total_cost;

% Constraints
% Minimum investment requirements
constraint invest_X >= min_invest_X;
constraint invest_Y >= min_invest_Y;

% Maximum total investment constraint
constraint invest_X + invest_Y <= max_total_invest;

% Minimum required interest income constraint
% Cast integer investments to float to ensure type consistency with float rates/threshold
constraint rate_X * int2float(invest_X) + rate_Y * int2float(invest_Y) >= min_interest_income;

% Total transaction cost definition
% Cast integer investments to float to ensure type consistency with float costs
constraint total_cost = cost_per_dollar_X * int2float(invest_X)
                      + cost_per_dollar_Y * int2float(invest_Y);

% Objective
solve minimize total_cost;