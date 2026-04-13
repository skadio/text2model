% Parameters (with values embedded)
int: cost1 = 5;
int: cost2 = 4;
int: cost3 = 3;

int: x1_lb = 0; int: x1_ub = 500;
int: x2_lb = 0; int: x2_ub = 300;
int: x3_lb = 0; int: x3_ub = 400;

% Variables
var x1_lb..x1_ub: x1;
var x2_lb..x2_ub: x2;
var x3_lb..x3_ub: x3;

var 0..(cost1*x1_ub + cost2*x2_ub + cost3*x3_ub): total_cost;

% Constraints
constraint x1 + 2*x2 <= 1000;
constraint 3*x1 - x2 + x3 >= 500;
constraint -x1 + 4*x2 - 2*x3 = 200;

constraint total_cost = cost1*x1 + cost2*x2 + cost3*x3;

% Objective
solve minimize total_cost;