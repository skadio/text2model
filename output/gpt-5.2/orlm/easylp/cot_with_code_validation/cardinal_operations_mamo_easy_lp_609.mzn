% Parameters
int: cost_x1 = 1000;
int: cost_x2 = 2000;
int: cost_x3 = 3000;
int: cost_x4 = 4000;

int: x1_lb = 0;   int: x1_ub = 500;
int: x2_lb = 0;   int: x2_ub = 400;
int: x3_lb = 0;   int: x3_ub = 600;
int: x4_lb = 0;   int: x4_ub = 700;

int: cap12 = 500;
int: cap34 = 800;

% Variables
var x1_lb..x1_ub: x1;
var x2_lb..x2_ub: x2;
var x3_lb..x3_ub: x3;
var x4_lb..x4_ub: x4;

var 0..(cost_x1*x1_ub + cost_x2*x2_ub + cost_x3*x3_ub + cost_x4*x4_ub): total_cost;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;

% (1/2)*x1 >= (1/4)*x3 + 50  ==>  2*x1 - x3 >= 200
constraint 2*x1 - x3 >= 200;

% (3/4)*x4 - x2 >= 100  ==>  3*x4 - 4*x2 >= 400
constraint 3*x4 - 4*x2 >= 400;

constraint total_cost = cost_x1*x1 + cost_x2*x2 + cost_x3*x3 + cost_x4*x4;

% Objective
solve minimize total_cost;