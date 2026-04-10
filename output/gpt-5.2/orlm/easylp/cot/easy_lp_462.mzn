% Parameters (with values embedded)
int: max_total_resources = 1000;
int: min_capacity = 2500;
int: balance_limit = 300;
int: cost_X = 7;
int: cost_Y = 5;

% Warehouse-specific bounds (not further specified in the description, so use nonnegative)
int: X_lb = 0;
int: Y_lb = 0;
int: X_ub = max_total_resources;
int: Y_ub = max_total_resources;

% Variables
var X_lb..X_ub: X;
var Y_lb..Y_ub: Y;
var 0..(cost_X*X_ub + cost_Y*Y_ub): total_cost;

% Constraints
constraint X + Y <= max_total_resources;
constraint 3*X + 2*Y >= min_capacity;
constraint abs(X - Y) <= balance_limit;

constraint total_cost = cost_X*X + cost_Y*Y;

% Objective
solve minimize total_cost;