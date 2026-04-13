% Parameters
% Minimum investment in option X (in thousands of dollars)
int: min_invest_X = 10000;

% Minimum investment in option Y (in thousands of dollars)
int: min_invest_Y = 5000;

% Minimum total investment across X and Y (in thousands of dollars)
int: min_total_invest = 20000;

% Maximum allowed "return-weighted" combined investment:
% 3*X + 4*Y <= max_return_weighted (in thousands of dollars)
int: max_return_weighted = 5000000;

% Return multipliers
int: return_mult_X = 3;
int: return_mult_Y = 4;

% Cost per unit of return (in dollars)
int: cost_per_return_X = 100;
int: cost_per_return_Y = 200;


% Variables
% Investment amounts (in thousands of dollars, integers)
var int: invest_X;
var int: invest_Y;

% Total cost in dollars (integer)
var int: total_cost;


% Constraints
%--- Minimum investment requirements for each option ---
constraint invest_X >= min_invest_X;
constraint invest_Y >= min_invest_Y;

%--- Risk diversification: minimum total invested across both options ---
constraint invest_X + invest_Y >= min_total_invest;

%--- Return-weighted combined investment must not exceed the maximum allowed ---
constraint return_mult_X * invest_X + return_mult_Y * invest_Y <= max_return_weighted;

%--- Define total cost (in dollars) based on cost per unit of return ---
constraint total_cost =
    cost_per_return_X * (return_mult_X * invest_X)
  + cost_per_return_Y * (return_mult_Y * invest_Y);


% Objective
solve minimize total_cost;