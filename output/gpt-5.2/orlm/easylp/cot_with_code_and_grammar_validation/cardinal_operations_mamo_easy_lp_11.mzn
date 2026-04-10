% Parameters
int: output_coef_x = 4;
int: output_coef_y = 6;
int: min_output = 12;

int: cons_coef_x = 3;
int: cons_coef_y = 5;
int: max_consumption = 15;

int: cost_x = 7;
int: cost_y = 10;

% Variables
var 0..max_consumption: x;
var 0..max_consumption: y;
var 0..(cost_x*max_consumption + cost_y*max_consumption): total_cost;

% Constraints
constraint output_coef_x * x + output_coef_y * y >= min_output;
constraint cons_coef_x * x + cons_coef_y * y <= max_consumption;
constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;