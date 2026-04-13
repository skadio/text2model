% Parameters (with values embedded)
int: cost1 = 5;
int: cost2 = 10;
int: cost3 = 7;
int: cost4 = 8;

int: max12 = 100;
int: max34 = 200;
int: min13 = 50;
int: min24 = 80;

int: x1_max = 60;
int: x2_max = 50;
int: x3_max = 150;
int: x4_max = 90;

% Variables
var 0..x1_max: x1;
var 0..x2_max: x2;
var 0..x3_max: x3;
var 0..x4_max: x4;

var 0..(cost1*x1_max + cost2*x2_max + cost3*x3_max + cost4*x4_max): total_cost;

% Constraints
constraint x1 + x2 <= max12;
constraint x3 + x4 <= max34;
constraint x1 + x3 >= min13;
constraint x2 + x4 >= min24;

constraint total_cost = cost1*x1 + cost2*x2 + cost3*x3 + cost4*x4;

% Objective
solve minimize total_cost;