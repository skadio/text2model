% Parameters
int: max_total = 1000;
int: min_balanced = 300;      % x - 2y >= 300
int: min_demand = 500;        % 3x + y >= 500

int: cost_x = 5;
int: cost_y = 2;

int: x_lb = 0;
int: x_ub = 600;
int: y_lb = 0;
int: y_ub = 500;

% Variables
var x_lb..x_ub: x;
var y_lb..y_ub: y;

var 0..(cost_x * x_ub + cost_y * y_ub): total_cost;

% Constraints
constraint x + y <= max_total;
constraint x - 2 * y >= min_balanced;
constraint 3 * x + y >= min_demand;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;