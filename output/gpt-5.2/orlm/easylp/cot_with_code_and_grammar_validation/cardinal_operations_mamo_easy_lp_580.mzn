% Parameters
int: total_resource_limit = 1000;
int: min_res_over_com = 50;
int: max_ind_res_diff = 200;
int: min_com_over_ind = 30;

int: cost_res = 200;
int: cost_com = 150;
int: cost_ind = 300;

% Variables
var 0..total_resource_limit: X; % residential
var 0..total_resource_limit: Y; % commercial
var 0..total_resource_limit: Z; % industrial

% Constraints
constraint X + Y + Z <= total_resource_limit;
constraint X >= Y + min_res_over_com;
constraint abs(Z - X) <= max_ind_res_diff;
constraint Y >= Z + min_com_over_ind;

% Objective
var 0..(total_resource_limit * max(cost_res, max(cost_com, cost_ind))): total_cost;
constraint total_cost = cost_res * X + cost_com * Y + cost_ind * Z;

solve minimize total_cost;