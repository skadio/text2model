% Parameters (with values embedded)
int: salary1 = 5000;
int: salary2 = 6000;
int: salary3 = 7000;
int: salary4 = 8000;

int: x1_lb = 0;  int: x1_ub = 20;
int: x2_lb = 0;  int: x2_ub = 20;
int: x3_lb = 0;  int: x3_ub = 15;
int: x4_lb = 0;  int: x4_ub = 15;

% Variables
var x1_lb..x1_ub: x1;
var x2_lb..x2_ub: x2;
var x3_lb..x3_ub: x3;
var x4_lb..x4_ub: x4;

var 0..(salary1*x1_ub + salary2*x2_ub + salary3*x3_ub + salary4*x4_ub): total_cost;

% Constraints
constraint x1 + x2 <= 40;
constraint x3 + x4 <= 30;

constraint x1 >= x3 + 10;
constraint x2 >= x4 + 5;

constraint total_cost = salary1*x1 + salary2*x2 + salary3*x3 + salary4*x4;

% Objective
solve minimize total_cost;