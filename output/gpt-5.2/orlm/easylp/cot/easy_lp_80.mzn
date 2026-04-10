% Parameters (with values embedded)
int: total_hours = 20;
int: hours_per_X = 5;
int: hours_per_Y = 3;

int: prod_X_coeff = 2;
int: prod_Y_coeff = 4;
int: min_productivity = 10;

int: cost_X = 50;
int: cost_Y = 80;

% Variables
var 0..(total_hours div hours_per_X): X;
var 0..(total_hours div hours_per_Y): Y;
var 0..10000: total_cost;

% Constraints
constraint hours_per_X * X + hours_per_Y * Y <= total_hours;
constraint prod_X_coeff * X + prod_Y_coeff * Y >= min_productivity;

constraint total_cost = cost_X * X + cost_Y * Y;

% Objective
solve minimize total_cost;