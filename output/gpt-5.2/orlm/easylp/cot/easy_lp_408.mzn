% Parameters (with values embedded)
int: cost1 = 100;
int: cost2 = 200;
int: cost3 = 150;
int: cost4 = 250;

int: x1_min = 0;    int: x1_max = 5000;
int: x2_min = 0;    int: x2_max = 5000;
int: x3_min = 0;    int: x3_max = 6000;
int: x4_min = 0;    int: x4_max = 6000;

int: cap12 = 5000;
int: cap34 = 6000;
int: min13 = 3000;
int: min24 = 4000;

% Variables
var x1_min..x1_max: x1;
var x2_min..x2_max: x2;
var x3_min..x3_max: x3;
var x4_min..x4_max: x4;

var 0..(cost1*x1_max + cost2*x2_max + cost3*x3_max + cost4*x4_max): total_cost;

% Constraints
constraint x1 + x2 <= cap12;
constraint x3 + x4 <= cap34;
constraint x1 + x3 >= min13;
constraint x2 + x4 >= min24;

constraint total_cost = cost1*x1 + cost2*x2 + cost3*x3 + cost4*x4;

% Objective
solve minimize total_cost;