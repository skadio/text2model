% Parameters
int: cost1 = 100;
int: cost2 = 200;
int: cost3 = 300;
int: cost4 = 400;

int: max12 = 500;
int: max34 = 600;

int: min13 = 300;
int: min24 = 400;

int: ub1 = 500;
int: ub2 = 500;
int: ub3 = 600;
int: ub4 = 600;

% Variables
var 0..ub1: x1;
var 0..ub2: x2;
var 0..ub3: x3;
var 0..ub4: x4;

var 0..(cost1*ub1 + cost2*ub2 + cost3*ub3 + cost4*ub4): total_cost;

% Constraints
constraint x1 + x2 <= max12;
constraint x3 + x4 <= max34;

constraint x1 + x3 >= min13;
constraint x2 + x4 >= min24;

constraint total_cost = cost1*x1 + cost2*x2 + cost3*x3 + cost4*x4;

% Objective
solve minimize total_cost;