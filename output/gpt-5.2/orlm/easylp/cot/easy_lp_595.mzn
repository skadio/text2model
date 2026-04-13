% Parameters (with values embedded)
int: cost_X1 = 4;
int: cost_X2 = 5;
int: cost_X3 = 6;
int: cost_X4 = 7;

int: UB_X1 = 1000;
int: UB_X2 = 1000;
int: UB_X3 = 1000;
int: UB_X4 = 1000;

% Variables
var 0..UB_X1: X1;
var 0..UB_X2: X2;
var 0..UB_X3: X3;
var 0..UB_X4: X4;

var int: total_cost;

% Constraints
constraint X1 + X2 <= 1000;
constraint X2 + X3 >= 800;
constraint X3 - X4 = 200;
constraint X4 - 2 * X1 <= 600; % (1/2)*X4 - X1 <= 300  ->  X4 - 2*X1 <= 600

constraint total_cost = cost_X1 * X1 + cost_X2 * X2 + cost_X3 * X3 + cost_X4 * X4;

% Objective
solve minimize total_cost;