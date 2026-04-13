% Parameters
int: cost_res = 50000;
int: cost_com = 30000;
int: cost_ind = 70000;

int: max_total_props = 10;

int: min_diff_res_com = 2;      % x >= y + 2
int: max_abs_diff_ind_res = 3;  % |z - x| <= 3

% Market availability bounds (not explicitly given beyond total cap)
int: lb_x = 0; int: ub_x = max_total_props;
int: lb_y = 0; int: ub_y = max_total_props;
int: lb_z = 0; int: ub_z = max_total_props;

% Variables
var lb_x..ub_x: x; % residential
var lb_y..ub_y: y; % commercial
var lb_z..ub_z: z; % industrial

var 0..(max_total_props * max(cost_res, max(cost_com, cost_ind))): total_cost;

% Constraints
constraint x + y + z <= max_total_props;

constraint x >= y + min_diff_res_com;

constraint abs(z - x) <= max_abs_diff_ind_res;

constraint total_cost = cost_res * x + cost_com * y + cost_ind * z;

% Objective
solve minimize total_cost;