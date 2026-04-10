% Parameters (with values embedded)
int: cost1 = 10;
int: cost2 = 15;
int: cost3 = 20;

int: max_x1 = 10000;
int: max_x2 = 8000;
int: max_x3 = 6000;

int: min_effectiveness = 5000;
int: limit_ineq2 = 1500;
int: eq3_rhs = 2000;

% Variables
var 0..max_x1: x1;
var 0..max_x2: x2;
var 0..max_x3: x3;

var int: total_cost;

% Constraints
constraint 5*x1 + 7*x2 + 9*x3 >= min_effectiveness;

constraint 3*x2 - x1 - 4*x3 <= limit_ineq2;

% x1 - 2.5*x2 - x3 = 2000  ==>  2*x1 - 5*x2 - 2*x3 = 4000
constraint 2*x1 - 5*x2 - 2*x3 = 2*eq3_rhs;

constraint total_cost = cost1*x1 + cost2*x2 + cost3*x3;

% Objective
solve minimize total_cost;