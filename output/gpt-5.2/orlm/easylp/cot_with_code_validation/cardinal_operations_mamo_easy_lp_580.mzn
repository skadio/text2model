% Parameters
int: B = 1000;
int: min_res_over_com = 50;
int: max_diff_ind_res = 200;
int: min_com_over_ind = 30;

int: cost_res = 200;
int: cost_com = 150;
int: cost_ind = 300;

% Variables
var 0..B: X; % residential
var 0..B: Y; % commercial
var 0..B: Z; % industrial

var 0..(cost_res*B + cost_com*B + cost_ind*B): total_cost;

% Constraints
constraint X + Y + Z <= B;

constraint X >= Y + min_res_over_com;

constraint abs(Z - X) <= max_diff_ind_res;

constraint Y >= Z + min_com_over_ind;

constraint total_cost = cost_res * X + cost_com * Y + cost_ind * Z;

% Objective
solve minimize total_cost;