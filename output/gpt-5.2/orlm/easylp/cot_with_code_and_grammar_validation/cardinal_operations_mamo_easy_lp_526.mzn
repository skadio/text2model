% Parameters
int: TOTAL_MAX = 5000;

int: X1_MAX = 3000;
int: X2_MAX = 2500;
int: X3_MAX = 1500;

int: EFFECT_MIN = 2000;

int: COST_X1 = 50;
int: COST_X2 = 75;
int: COST_X3 = 60;

% Variables
var 0..X1_MAX: X1;
var 0..X2_MAX: X2;
var 0..X3_MAX: X3;

var 0..(COST_X1*X1_MAX + COST_X2*X2_MAX + COST_X3*X3_MAX): total_cost;

% Constraints
constraint X1 + X2 + X3 <= TOTAL_MAX;

% Effectiveness: 0.5*X1 + 0.4*X2 + 0.6*X3 >= 2000
% Multiply by 10 to keep everything integer: 5*X1 + 4*X2 + 6*X3 >= 20000
constraint 5*X1 + 4*X2 + 6*X3 >= 10 * EFFECT_MIN;

% Balance: | 2*X2 - (X1 + X3) | <= 100
constraint abs(2*X2 - (X1 + X3)) <= 100;

constraint total_cost = COST_X1*X1 + COST_X2*X2 + COST_X3*X3;

% Objective
solve minimize total_cost;