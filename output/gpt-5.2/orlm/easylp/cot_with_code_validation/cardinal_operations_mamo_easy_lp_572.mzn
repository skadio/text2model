% Parameters
int: total_cap = 100;

int: cost1 = 50000;
int: cost2 = 70000;
int: cost3 = 60000;

int: x1_lb = 10; int: x1_ub = 50;
int: x2_lb = 20; int: x2_ub = 70;
int: x3_lb = 0;  int: x3_ub = 40;

% Variables
var x1_lb..x1_ub: x1;
var x2_lb..x2_ub: x2;
var x3_lb..x3_ub: x3;

var 0..(cost1*x1_ub + cost2*x2_ub + cost3*x3_ub): total_cost;

% Constraints
constraint x1 + x2 + x3 <= total_cap;

% 0.5*x1 + 0.6*x3 >= 0.7*x2 + 20  -> multiply by 10: 5x1 + 6x3 - 7x2 >= 200
constraint 5*x1 + 6*x3 - 7*x2 >= 200;

% 0.8*x2 + 0.9*x3 <= x1 + 30      -> multiply by 10: 8x2 + 9x3 - 10x1 <= 300
constraint 8*x2 + 9*x3 - 10*x1 <= 300;

constraint total_cost = cost1*x1 + cost2*x2 + cost3*x3;

% Objective
solve minimize total_cost;