% Parameters
int: util_coef_x = 5;
int: util_coef_y = 3;
int: util_cap = 100;

int: service_coef_x = 2;
int: service_coef_y = 1;
int: service_min = 30;

int: balance_max_diff = 10;

int: cost_x = 10;
int: cost_y = 20;

% Variables
var 0..(util_cap div util_coef_x): x;
var 0..(util_cap div util_coef_y): y;
var 0..(cost_x*(util_cap div util_coef_x) + cost_y*(util_cap div util_coef_y)): total_cost;

% Constraints
constraint util_coef_x * x + util_coef_y * y <= util_cap;

constraint service_coef_x * x + service_coef_y * y >= service_min;

constraint x - y <= balance_max_diff;
constraint y - x <= balance_max_diff;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;