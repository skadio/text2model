% Parameters
int: cost_P1 = 1000;
int: cost_P2 = 2000;
int: cost_P3 = 3000;
int: cost_P4 = 4000;

int: max_P1 = 10;
int: max_P2 = 15;
int: max_P3 = 12;
int: max_P4 = 8;

% Variables
var 0..max_P1: x1;
var 0..max_P2: x2;
var 0..max_P3: x3;
var 0..max_P4: x4;

var 0..(cost_P1*max_P1 + cost_P2*max_P2 + cost_P3*max_P3 + cost_P4*max_P4): total_cost;

% Constraints
constraint x1 + x2 <= 20;
constraint x2 + x3 >= 10;
constraint abs(x3 - x4) <= 5;
constraint 2*x1 + 3*x2 - x4 >= 15;

constraint total_cost = cost_P1*x1 + cost_P2*x2 + cost_P3*x3 + cost_P4*x4;

% Objective
solve minimize total_cost;