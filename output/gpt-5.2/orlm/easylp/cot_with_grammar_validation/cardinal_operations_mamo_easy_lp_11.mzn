% Parameters
int: min_output = 12;
int: max_consumption = 15;

int: output_x = 4;
int: output_y = 6;

int: cons_x = 3;
int: cons_y = 5;

int: cost_x = 7;
int: cost_y = 10;

% Variables
var 0..100: x;
var 0..100: y;
var 0..10000: total_cost;

% Constraints
constraint output_x * x + output_y * y >= min_output;
constraint cons_x * x + cons_y * y <= max_consumption;

constraint total_cost = cost_x * x + cost_y * y;

% Objective
solve minimize total_cost;