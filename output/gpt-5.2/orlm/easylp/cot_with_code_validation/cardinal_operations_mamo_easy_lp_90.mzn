% Parameters
int: total_budget = 5000;
int: min_ratio = 2;                  % X >= 2*Y
int: service_min = 1000;             % 2*X + 1*Y >= 1000
int: coeff_service_x = 2;
int: coeff_service_y = 1;
int: cost_x = 4;
int: cost_y = 3;

% Variables
var 0..total_budget: X;
var 0..total_budget: Y;
var 0..(cost_x*total_budget + cost_y*total_budget): total_cost;

% Constraints
constraint X + Y <= total_budget;
constraint X >= min_ratio * Y;
constraint coeff_service_x * X + coeff_service_y * Y >= service_min;

constraint total_cost = cost_x * X + cost_y * Y;

% Objective
solve minimize total_cost;