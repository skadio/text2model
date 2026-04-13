% Parameters (with values embedded)
int: total_max = 10;
int: min_X1 = 2;
int: min_X2 = 3;
int: min_X3 = 5;

int: lb_X1 = 0; int: ub_X1 = 6;
int: lb_X2 = 0; int: ub_X2 = 4;
int: lb_X3 = 0; int: ub_X3 = 5;

int: cost_X1 = 50000;
int: cost_X2 = 60000;
int: cost_X3 = 70000;

% Variables
var lb_X1..ub_X1: X1;
var lb_X2..ub_X2: X2;
var lb_X3..ub_X3: X3;

var 0..(total_max * max([cost_X1, cost_X2, cost_X3])): total_cost;

% Constraints
constraint X1 + X2 + X3 <= total_max;

constraint X1 >= min_X1;
constraint X2 >= min_X2;
constraint X3 >= min_X3;

constraint total_cost = cost_X1 * X1 + cost_X2 * X2 + cost_X3 * X3;

% Objective
solve minimize total_cost;