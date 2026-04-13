% Parameters
int: max_total = 10;
int: min_x1 = 2;
int: min_x2 = 3;
int: min_x3 = 5;

int: lb_x1 = 0; int: ub_x1 = 6;
int: lb_x2 = 0; int: ub_x2 = 4;
int: lb_x3 = 0; int: ub_x3 = 5;

int: cost_x1 = 50000;
int: cost_x2 = 60000;
int: cost_x3 = 70000;

% Variables
var lb_x1..ub_x1: X1;
var lb_x2..ub_x2: X2;
var lb_x3..ub_x3: X3;

var 0..(ub_x1*cost_x1 + ub_x2*cost_x2 + ub_x3*cost_x3): total_cost;

% Constraints
constraint X1 >= min_x1;
constraint X2 >= min_x2;
constraint X3 >= min_x3;

constraint X1 + X2 + X3 <= max_total;

constraint total_cost = cost_x1 * X1 + cost_x2 * X2 + cost_x3 * X3;

% Objective
solve minimize total_cost;