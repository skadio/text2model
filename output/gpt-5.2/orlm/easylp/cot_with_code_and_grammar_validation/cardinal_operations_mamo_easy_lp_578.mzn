% Parameters
int: max_total_investment = 50;
int: min_weighted_investment = 30;

int: max_diff_x_y = 10;
int: min_y_minus_z = 5;

int: cost_x = 500;
int: cost_y = 700;
int: cost_z = 900;

% Individual upper limits (not specified beyond total budget, so use total budget as safe upper bounds)
int: ub_x = max_total_investment;
int: ub_y = max_total_investment;
int: ub_z = max_total_investment;

% Variables
var 0..ub_x: x; % residential units
var 0..ub_y: y; % commercial units
var 0..ub_z: z; % industrial units

var 0..(cost_x*ub_x + cost_y*ub_y + cost_z*ub_z): total_cost;

% Constraints
constraint x + y + z <= max_total_investment;

constraint 2*x + 3*y + z >= min_weighted_investment;

constraint abs(x - y) <= max_diff_x_y;

constraint y >= z + min_y_minus_z;

constraint total_cost = cost_x*x + cost_y*y + cost_z*z;

% Objective
solve minimize total_cost;