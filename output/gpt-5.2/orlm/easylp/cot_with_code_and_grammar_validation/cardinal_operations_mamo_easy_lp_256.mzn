% Parameters
int: budget = 100;
int: demand_min = 50;
int: risk_max = 30;

int: c1 = 5;
int: c2 = 4;
int: c3 = 3;

int: max_x1 = 100;
int: max_x2 = 100;
int: max_x3 = 100;

% Variables
var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;

var 0..(c1*max_x1 + c2*max_x2 + c3*max_x3): total_cost;

% Constraints
constraint x1 + x2 + x3 <= budget;

constraint 2*x1 + 3*x2 >= demand_min;

constraint 4*x1 - 5*x3 <= risk_max;

constraint total_cost = c1*x1 + c2*x2 + c3*x3;

% Objective
solve minimize total_cost;