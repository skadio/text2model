% Parameters
int: total_invest_max = 50;
int: portfolio_min = 30;
int: diff_xy_max = 10;
int: y_minus_z_min = 5;

int: cost_x = 500;
int: cost_y = 700;
int: cost_z = 900;

% (No explicit individual upper limits provided beyond total budget; use total as safe bounds)
int: x_ub = total_invest_max;
int: y_ub = total_invest_max;
int: z_ub = total_invest_max;

% Variables
var 0..x_ub: x;
var 0..y_ub: y;
var 0..z_ub: z;

var 0..(cost_x * x_ub + cost_y * y_ub + cost_z * z_ub): total_cost;

% Constraints
constraint x + y + z <= total_invest_max;

constraint 2 * x + 3 * y + z >= portfolio_min;

constraint abs(x - y) <= diff_xy_max;

constraint y >= z + y_minus_z_min;

constraint total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;