% Parameters
int: BUDGET = 5000;
int: EFFECT_MIN = 3000;
int: LOG_MAX = 2500;

int: c1 = 5;
int: c2 = 3;
int: c3 = 7;

% Variables
var 0..BUDGET: X1;
var 0..BUDGET: X2;
var 0..BUDGET: X3;

var 0..(c1*BUDGET + c2*BUDGET + c3*BUDGET): total_cost;

% Constraints
constraint X1 + X2 + X3 <= BUDGET;

constraint 4 * X1 + 6 * X3 >= EFFECT_MIN;

% 2*X2 + 3*(X3/2) <= 2500  -> 4*X2 + 3*X3 <= 5000 (multiply by 2)
constraint 4 * X2 + 3 * X3 <= 2 * LOG_MAX;

constraint total_cost = c1 * X1 + c2 * X2 + c3 * X3;

% Objective
solve minimize total_cost;