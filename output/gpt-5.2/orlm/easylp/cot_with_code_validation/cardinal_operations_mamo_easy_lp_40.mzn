% Parameters
int: min_X = 10;          % thousand dollars
int: min_Y = 5;           % thousand dollars
int: min_total = 20;      % thousand dollars
int: max_return_cap = 5000; % in "return units" consistent with 3*X + 4*Y

int: return_X = 3;
int: return_Y = 4;

int: cost_per_return_X = 100; % dollars per unit of return
int: cost_per_return_Y = 200; % dollars per unit of return

% Variables
var min_X..max_return_cap: X; % thousand dollars, integer
var min_Y..max_return_cap: Y; % thousand dollars, integer

var 0..(cost_per_return_X*return_X*max_return_cap + cost_per_return_Y*return_Y*max_return_cap): total_cost;

% Constraints
constraint X >= min_X;
constraint Y >= min_Y;

constraint X + Y >= min_total;

constraint return_X * X + return_Y * Y <= max_return_cap;

constraint total_cost = cost_per_return_X * return_X * X + cost_per_return_Y * return_Y * Y;

% Objective
solve minimize total_cost;