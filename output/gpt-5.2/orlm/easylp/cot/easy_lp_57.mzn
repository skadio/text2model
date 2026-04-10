% Parameters (with values embedded)
int: max_total_budget = 2000;
int: cost_X = 2;
int: cost_Y = 3;
int: X_min = 0;
int: X_max = 1500;
int: Y_min = 0;
int: Y_max = 1000;

% Variables
var X_min..X_max: X;
var Y_min..Y_max: Y;
var 0..(cost_X*X_max + cost_Y*Y_max): total_cost;

% Constraints
constraint X + Y <= max_total_budget;
constraint 2*X >= Y + 1000; % X must be at least half of Y plus 500: X >= 0.5*Y + 500
constraint total_cost = cost_X*X + cost_Y*Y;

% Objective
solve minimize total_cost;