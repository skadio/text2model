% Parameters
int: budget = 10;
int: req = 6;

int: coeff_budget_x = 4;
int: coeff_budget_y = 1;

int: coeff_req_x = 1;
int: coeff_req_y = 2;

int: cost_x = 7;
int: cost_y = 3;

% Variables
var 0..budget: x;
var 0..budget: y;
var 0..(cost_x*budget + cost_y*budget): total_cost;

% Constraints
constraint coeff_budget_x * x + coeff_budget_y * y <= budget;
constraint coeff_req_x * x + coeff_req_y * y >= req;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;