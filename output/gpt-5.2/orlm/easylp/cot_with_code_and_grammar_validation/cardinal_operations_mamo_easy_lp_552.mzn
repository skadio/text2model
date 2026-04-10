% Parameters
int: total_max = 10;

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
var lb_x1..ub_x1: x1;
var lb_x2..ub_x2: x2;
var lb_x3..ub_x3: x3;

var 0..(ub_x1*cost_x1 + ub_x2*cost_x2 + ub_x3*cost_x3): total_cost;

% Constraints
constraint x1 >= min_x1;
constraint x2 >= min_x2;
constraint x3 >= min_x3;

constraint x1 + x2 + x3 <= total_max;

constraint total_cost = cost_x1*x1 + cost_x2*x2 + cost_x3*x3;

% Objective
solve minimize total_cost;