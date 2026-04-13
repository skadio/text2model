% Parameters (with values embedded)
int: cost_X1 = 5000;
int: cost_X2 = 4000;
int: cost_X3 = 6000;
int: cost_X4 = 7000;

int: ub_X1 = 30;
int: ub_X2 = 40;
int: ub_X3 = 50;
int: ub_X4 = 60;

% Variables
var 0..ub_X1: X1;
var 0..ub_X2: X2;
var 0..ub_X3: X3;
var 0..ub_X4: X4;

var int: total_cost;

% Constraints
constraint X1 + X2 >= 10;
constraint X3 + X4 <= 20;
constraint 2 * X2 - X1 - X3 >= 5;
constraint X4 - X1 - X2 >= 5;

constraint total_cost = cost_X1 * X1 + cost_X2 * X2 + cost_X3 * X3 + cost_X4 * X4;

% Objective
solve minimize total_cost;