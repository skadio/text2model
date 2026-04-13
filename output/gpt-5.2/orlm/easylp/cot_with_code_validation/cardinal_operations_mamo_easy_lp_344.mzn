% Parameters
int: budget12 = 1000;
int: budget34 = 500;

int: cost1 = 10;
int: cost2 = 15;
int: cost3 = 20;
int: cost4 = 25;

int: min_return12 = 50;
int: max_netloss34 = -20;

% Variables
var 0..budget12: x1;
var 0..budget12: x2;
var 0..budget34: x3;
var 0..budget34: x4;

% Constraints
constraint x1 + x2 <= budget12;

% 0.05*x1 + 0.07*x2 >= 50  ==>  5*x1 + 7*x2 >= 5000 (scaled by 100)
constraint 5*x1 + 7*x2 >= 100 * min_return12;

constraint x3 + x4 <= budget34;

% -0.03*x3 -0.04*x4 <= -20  ==>  -3*x3 -4*x4 <= -2000 (scaled by 100)
constraint -3*x3 - 4*x4 <= 100 * max_netloss34;

% Objective
var int: total_cost = cost1*x1 + cost2*x2 + cost3*x3 + cost4*x4;
solve minimize total_cost;