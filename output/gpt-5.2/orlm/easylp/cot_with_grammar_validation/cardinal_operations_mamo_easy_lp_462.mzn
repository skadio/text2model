% Parameters
int: total_limit = 1000;
int: capacity_req = 2500;
int: diff_limit = 300;
int: cost_x = 7;
int: cost_y = 5;

% Variables
var 0..total_limit: X;
var 0..total_limit: Y;
var 0..(cost_x * total_limit + cost_y * total_limit): total_cost;

% Constraints
constraint X + Y <= total_limit;
constraint 3 * X + 2 * Y >= capacity_req;
constraint abs(X - Y) <= diff_limit;

constraint total_cost = cost_x * X + cost_y * Y;

% Objective
solve minimize total_cost;