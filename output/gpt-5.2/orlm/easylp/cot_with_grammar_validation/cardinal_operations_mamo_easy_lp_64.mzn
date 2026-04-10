% Parameters
int: cost_x = 500;
int: cost_y = 700;
int: perf_req = 2000;
int: res_cap = 1500;

% Variables
var 0..res_cap: x;
var 0..res_cap: y;
var 0..(cost_x*res_cap + cost_y*res_cap): total_cost;

% Constraints
constraint 2*x + 3*y >= perf_req;
constraint x + y <= res_cap;
constraint total_cost = cost_x*x + cost_y*y;

% Objective
solve minimize total_cost;