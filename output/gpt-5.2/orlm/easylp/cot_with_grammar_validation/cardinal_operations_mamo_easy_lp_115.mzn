% Parameters
int: budget_max = 100;
int: eff_min = 150;

int: eff_x_coef = 2;
int: eff_y_coef = 3;

int: cost_x = 20;
int: cost_y = 30;

% Variables
var 0..budget_max: x;  % dollars allocated to campaign X
var 0..budget_max: y;  % dollars allocated to campaign Y
var 0..(cost_x*budget_max + cost_y*budget_max): total_cost;

% Constraints
constraint x + y <= budget_max;

constraint eff_x_coef * x + eff_y_coef * y >= eff_min;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;