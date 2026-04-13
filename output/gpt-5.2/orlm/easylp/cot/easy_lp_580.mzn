% Parameters (with values embedded)
int: budget = 1000;
int: min_res_over_com = 50;
int: max_ind_res_diff = 200;
int: min_com_over_ind = 30;

int: cost_res = 200;
int: cost_com = 150;
int: cost_ind = 300;

% Variables
var 0..budget: X; % residential units
var 0..budget: Y; % commercial units
var 0..budget: Z; % industrial units

var 0..(cost_res*budget + cost_com*budget + cost_ind*budget): total_cost;

% Constraints
constraint X + Y + Z <= budget;
constraint X >= Y + min_res_over_com;
constraint abs(Z - X) <= max_ind_res_diff;
constraint Y >= Z + min_com_over_ind;

constraint total_cost = cost_res*X + cost_com*Y + cost_ind*Z;

% Objective
solve minimize total_cost;