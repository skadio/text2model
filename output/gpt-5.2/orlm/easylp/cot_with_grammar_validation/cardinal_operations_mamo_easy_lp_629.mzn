% Parameters
int: cost1 = 5000;
int: cost2 = 6000;
int: cost3 = 7000;
int: cost4 = 8000;

int: max12 = 40;
int: max34 = 30;

int: diff13 = 10;
int: diff24 = 5;

int: x1_lb = 0;  int: x1_ub = 20;
int: x2_lb = 0;  int: x2_ub = 20;
int: x3_lb = 0;  int: x3_ub = 15;
int: x4_lb = 0;  int: x4_ub = 15;

% Variables
var x1_lb..x1_ub: x1;
var x2_lb..x2_ub: x2;
var x3_lb..x3_ub: x3;
var x4_lb..x4_ub: x4;

var 0..(cost1*x1_ub + cost2*x2_ub + cost3*x3_ub + cost4*x4_ub): total_cost;

% Constraints
constraint x1 + x2 <= max12;
constraint x3 + x4 <= max34;

constraint x1 >= x3 + diff13;
constraint x2 >= x4 + diff24;

constraint total_cost = cost1*x1 + cost2*x2 + cost3*x3 + cost4*x4;

% Objective
solve minimize total_cost;