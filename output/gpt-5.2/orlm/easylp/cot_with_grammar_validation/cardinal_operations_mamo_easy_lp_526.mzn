% Parameters
int: total_budget = 5000;
int: min_effectiveness = 2000;

int: c1 = 50;
int: c2 = 75;
int: c3 = 60;

int: x1_max = 3000;
int: x2_max = 2500;
int: x3_max = 1500;

int: diff_max = 100;

% Variables
var 0..x1_max: x1;
var 0..x2_max: x2;
var 0..x3_max: x3;

var 0..(c1*x1_max + c2*x2_max + c3*x3_max): total_cost;

% Constraints
constraint x1 + x2 + x3 <= total_budget;

% Effectiveness: 0.5*x1 + 0.4*x2 + 0.6*x3 >= 2000
% Multiply by 10 to keep integer linear form: 5*x1 + 4*x2 + 6*x3 >= 20000
constraint 5*x1 + 4*x2 + 6*x3 >= 10 * min_effectiveness;

constraint abs(2*x2 - (x1 + x3)) <= diff_max;

constraint total_cost = c1*x1 + c2*x2 + c3*x3;

% Objective
solve minimize total_cost;