% Parameters
int: total_invest_max = 50;
int: min_weighted_invest = 30;
int: diff_xy_max = 10;
int: y_minus_z_min = 5;

int: cost_x = 500;
int: cost_y = 700;
int: cost_z = 900;

% Variables
var 0..total_invest_max: x;
var 0..total_invest_max: y;
var 0..total_invest_max: z;

var 0..(cost_x*total_invest_max + cost_y*total_invest_max + cost_z*total_invest_max): total_cost;

% Constraints
constraint x + y + z <= total_invest_max;

constraint 2*x + 3*y + z >= min_weighted_invest;

constraint abs(x - y) <= diff_xy_max;

constraint y >= z + y_minus_z_min;

constraint total_cost = cost_x*x + cost_y*y + cost_z*z;

% Objective
solve minimize total_cost;