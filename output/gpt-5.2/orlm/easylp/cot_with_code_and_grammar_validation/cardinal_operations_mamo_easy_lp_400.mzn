% Parameters
int: max_X1_X2 = 200;
int: max_X3_X4 = 150;

int: req_strength_12 = 1000;
int: req_strength_34 = 750;

int: cost_X1 = 5000;
int: cost_X2 = 7000;
int: cost_X3 = 10000;
int: cost_X4 = 3000;

% Strength coefficients (scaled by 2 to avoid decimals: 7.5 -> 15/2)
int: a1 = 5;
int: a2 = 10;

int: a3_scaled2 = 15; % 7.5 * 2
int: a4_scaled2 = 10; % 5 * 2
int: req_strength_34_scaled2 = req_strength_34 * 2;

% Variables
var 0..max_X1_X2: X1;
var 0..max_X1_X2: X2;
var 0..max_X3_X4: X3;
var 0..max_X3_X4: X4;

var 0..(cost_X1*max_X1_X2 + cost_X2*max_X1_X2 + cost_X3*max_X3_X4 + cost_X4*max_X3_X4): total_cost;

% Constraints
constraint X1 + X2 <= max_X1_X2;
constraint X3 + X4 <= max_X3_X4;

constraint a1*X1 + a2*X2 >= req_strength_12;
constraint a3_scaled2*X3 + a4_scaled2*X4 >= req_strength_34_scaled2;

constraint total_cost = cost_X1*X1 + cost_X2*X2 + cost_X3*X3 + cost_X4*X4;

% Objective
solve minimize total_cost;