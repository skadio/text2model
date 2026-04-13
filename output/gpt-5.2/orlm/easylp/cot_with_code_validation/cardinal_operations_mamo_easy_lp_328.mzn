% Parameters
int: cost_res = 50000;
int: cost_com = 30000;
int: cost_ind = 70000;

int: max_total = 10;

int: min_diff_res_com = 2;      % x >= y + 2
int: max_abs_diff_ind_res = 3;  % |z - x| <= 3

int: min_res = 0; int: max_res = 10;
int: min_com = 0; int: max_com = 10;
int: min_ind = 0; int: max_ind = 10;

% Variables
var min_res..max_res: x; % residential
var min_com..max_com: y; % commercial
var min_ind..max_ind: z; % industrial

var 0..(max_total * max(cost_res, max(cost_com, cost_ind))): total_cost;

% Constraints
constraint x + y + z <= max_total;

constraint x >= y + min_diff_res_com;

constraint abs(z - x) <= max_abs_diff_ind_res;

constraint total_cost = cost_res * x + cost_com * y + cost_ind * z;

% Objective
solve minimize total_cost;