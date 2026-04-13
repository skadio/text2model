% Parameters
int: cost_X = 5;              % Daily operating cost per type X vehicle
int: cost_Y = 10;             % Daily operating cost per type Y vehicle
int: min_X  = 30;             % Minimum number of type X vehicles required per day
int: min_Y  = 20;             % Minimum number of type Y vehicles required per day
int: max_total = 100;         % Maximum total vehicles (X + Y) allowed per day

% Variables
var min_X..max_total: num_X;  % Number of type X vehicles operated (integer)
var min_Y..max_total: num_Y;  % Number of type Y vehicles operated (integer)
var 0..(cost_X*max_total + cost_Y*max_total): total_cost; % Total daily operational cost

% Constraints
% Vehicle availability / budget-capacity constraint (total vehicles limit)
constraint num_X + num_Y <= max_total;

% Cost accounting constraint (define total_cost from chosen vehicles)
constraint total_cost = cost_X * num_X + cost_Y * num_Y;

% Objective
solve minimize total_cost;