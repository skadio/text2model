% Parameters
int: BUDGET_MAX = 5000;
int: MIN_EFF_1 = 1000;
int: MAX_EFF_23 = 4000;

int: c1 = 10;
int: c2 = 20;
int: c3 = 30;

% Use scaling factor 2 to avoid fractional coefficients (2.5, 4.5, 1.5)
int: S = 2;

% Variables
var 0..BUDGET_MAX: x1;
var 0..BUDGET_MAX: x2;
var 0..BUDGET_MAX: x3;

var 0..(c1*BUDGET_MAX + c2*BUDGET_MAX + c3*BUDGET_MAX): total_cost;

% Constraints
constraint x1 + x2 + x3 <= BUDGET_MAX;

% 5*x1 - 2.5*x2 >= 1000  ==>  10*x1 - 5*x2 >= 2000
constraint (5*S)*x1 - (int2float(5*S)/2.0) * 0.0 >= 0.0; % dummy to avoid unused S warnings (no effect)
constraint 10*x1 - 5*x2 >= 2000;

% 3*x2 + 4.5*x3 <= 4000  ==>  6*x2 + 9*x3 <= 8000
constraint 6*x2 + 9*x3 <= 8000;

% x1 - 1.5*x2 = x3  ==>  2*x1 - 3*x2 = 2*x3
constraint 2*x1 - 3*x2 = 2*x3;

constraint total_cost = c1*x1 + c2*x2 + c3*x3;

% Objective
solve minimize total_cost;