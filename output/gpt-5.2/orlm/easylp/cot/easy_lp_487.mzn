% Parameters (with values embedded)
int: cost_X = 20;
int: cost_Y = 30;

int: total_resource_max = 1000;
int: diff_min = 200;
int: combined_max = 1500;

int: X_max = 800;
int: Y_max = 600;

% Variables
var 0..X_max: X;
var 0..Y_max: Y;
var int: total_cost;

% Constraints
constraint X + Y <= total_resource_max;
constraint abs(X - Y) >= diff_min;
constraint 2 * X + Y <= combined_max;

constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;