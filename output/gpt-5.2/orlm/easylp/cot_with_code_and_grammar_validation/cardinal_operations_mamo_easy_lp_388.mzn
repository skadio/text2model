% Parameters
int: cost1 = 50;
int: cost2 = 100;
int: cost3 = 200;
int: cost4 = 300;

int: x1_lb = 0;   int: x1_ub = 500;
int: x2_lb = 0;   int: x2_ub = 400;
int: x3_lb = 0;   int: x3_ub = 600;
int: x4_lb = 0;   int: x4_ub = 700;

% Variables
var x1_lb..x1_ub: x1;
var x2_lb..x2_ub: x2;
var x3_lb..x3_ub: x3;
var x4_lb..x4_ub: x4;

var 0..(cost1*x1_ub + cost2*x2_ub + cost3*x3_ub + cost4*x4_ub): total_cost;

% Constraints
constraint x1 + x2 <= 500;
constraint x2 + x3 >= 300;
constraint abs(x3 - x4) <= 100;
constraint x4 - x1 >= 50;

constraint total_cost = cost1*x1 + cost2*x2 + cost3*x3 + cost4*x4;

% Objective
solve minimize total_cost;