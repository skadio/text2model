% Parameters (with values embedded)
int: total_capacity = 5000;
int: x_min = 1000;
int: y_max = 3000;

int: cost_x = 50;
int: cost_y = 75;

% Variables
var 0..total_capacity: x;
var 0..total_capacity: y;
var 0..(cost_x*total_capacity + cost_y*total_capacity): total_cost;

% Constraints
constraint x + y <= total_capacity;
constraint x >= x_min;
constraint y <= y_max;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;