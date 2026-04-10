% Parameters
int: cost_x1 = 4;
int: cost_x2 = 5;
int: cost_x3 = 6;

int: max_x1 = 1500;
int: max_x2 = 1200;
int: max_x3 = 800;

int: cap_x1_x2 = 2000;
int: min_x2_x3 = 1000;

int: eq_rhs = 500;

% Variables
var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;

var 0..(cost_x1*max_x1 + cost_x2*max_x2 + cost_x3*max_x3): total_cost;

% Constraints
constraint x1 + x2 <= cap_x1_x2;
constraint x2 + x3 >= min_x2_x3;
constraint x1 - 2*x3 = eq_rhs;

constraint total_cost = cost_x1*x1 + cost_x2*x2 + cost_x3*x3;

% Objective
solve minimize total_cost;