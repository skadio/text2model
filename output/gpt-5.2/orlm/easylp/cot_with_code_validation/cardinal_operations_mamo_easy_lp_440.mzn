% Parameters
int: budget = 100;
int: service_min = 30;
int: balance_max = 10;

int: util_x = 5;
int: util_y = 3;

int: service_x = 2;
int: service_y = 1;

int: cost_x = 10;
int: cost_y = 20;

% Variables
var 0..budget: x;
var 0..budget: y;
var 0..(cost_x*budget + cost_y*budget): total_cost;

% Constraints
constraint util_x * x + util_y * y <= budget;
constraint service_x * x + service_y * y >= service_min;
constraint abs(x - y) <= balance_max;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;