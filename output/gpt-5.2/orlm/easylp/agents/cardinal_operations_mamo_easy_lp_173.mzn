% Parameters
% Budget limit
int: total_budget_limit = 5000;

% Minimum/maximum effectiveness requirements (right-hand sides)
int: rhs1_min = 2000;   % 3*X - Y + Z >= 2000
int: rhs2_max = 1000;   % X - 2*Y - Z <= 1000
int: rhs3_min = 1500;   % X - Y + 3*Z >= 1500

% Cost per unit budget for each channel
int: cost_X = 60;
int: cost_Y = 75;
int: cost_Z = 50;


% Variables
% Integer budgets allocated to channels X, Y, Z (whole dollars, nonnegative)
var 0..total_budget_limit: budget_X;
var 0..total_budget_limit: budget_Y;
var 0..total_budget_limit: budget_Z;

% Total cost to minimize (explicit upper bound for linear objective safety)
var 0..(total_budget_limit * max([cost_X, cost_Y, cost_Z])): total_cost;


% Constraints
%----------------------------
% Total budget limit
%----------------------------
constraint budget_X + budget_Y + budget_Z <= total_budget_limit;

%----------------------------
% Effectiveness/feasibility requirements
%----------------------------

% 3*X - Y + Z >= 2000
constraint 3 * budget_X - budget_Y + budget_Z >= rhs1_min;

% X - 2*Y - Z <= 1000
constraint budget_X - 2 * budget_Y - budget_Z <= rhs2_max;

% X - Y + 3*Z >= 1500
constraint budget_X - budget_Y + 3 * budget_Z >= rhs3_min;

%----------------------------
% Total cost definition
%----------------------------
constraint total_cost = cost_X * budget_X + cost_Y * budget_Y + cost_Z * budget_Z;


% Objective
solve minimize total_cost;