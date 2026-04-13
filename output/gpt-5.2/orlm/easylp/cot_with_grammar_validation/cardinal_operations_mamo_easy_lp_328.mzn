% Parameters
int: cost_res = 50000;
int: cost_com = 30000;
int: cost_ind = 70000;

int: max_total = 10;

int: min_res_minus_com = 2;
int: max_abs_ind_minus_res = 3;

% Market availability bounds (not explicitly given; assume only non-negativity)
int: lb_res = 0;
int: lb_com = 0;
int: lb_ind = 0;

int: ub_res = max_total;
int: ub_com = max_total;
int: ub_ind = max_total;

% Variables
var lb_res..ub_res: x; % residential
var lb_com..ub_com: y; % commercial
var lb_ind..ub_ind: z; % industrial

var 0..(cost_res*ub_res + cost_com*ub_com + cost_ind*ub_ind): total_cost;

% Constraints
constraint x + y + z <= max_total;

constraint x >= y + min_res_minus_com;

constraint abs(z - x) <= max_abs_ind_minus_res;

constraint total_cost = cost_res * x + cost_com * y + cost_ind * z;

% Objective
solve minimize total_cost;