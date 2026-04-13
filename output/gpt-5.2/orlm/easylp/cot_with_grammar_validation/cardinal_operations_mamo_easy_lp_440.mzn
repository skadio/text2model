% Parameters
int: budget = 100;
int: min_service = 30;
int: max_diff = 10;

int: util_x = 5;
int: util_y = 3;

int: svc_x = 2;
int: svc_y = 1;

int: cost_x = 10;
int: cost_y = 20;

% Variables
var 0..budget: x;
var 0..budget: y;
var 0..(cost_x*budget + cost_y*budget): total_cost;

% Constraints
constraint util_x * x + util_y * y <= budget;
constraint svc_x * x + svc_y * y >= min_service;
constraint abs(x - y) <= max_diff;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;