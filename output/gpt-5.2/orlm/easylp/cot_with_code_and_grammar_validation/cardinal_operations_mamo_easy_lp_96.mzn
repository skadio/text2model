% Parameters
int: total_cap = 100;
int: min_balance = 50;
int: max_diff = 30;

int: cost_x = 2;
int: cost_y = 3;

% Variables
var 0..total_cap: X;
var 0..total_cap: Y;

var 0..(cost_x*total_cap + cost_y*total_cap): total_cost;

% Constraints
constraint X + Y <= total_cap;
constraint 2*X + Y >= min_balance;
constraint abs(X - Y) <= max_diff;

constraint total_cost = cost_x*X + cost_y*Y;

% Objective
solve minimize total_cost;