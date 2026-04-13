% Parameters
int: TOTAL_MAX = 100;

int: X1_min = 0;
int: X1_max = 100;
int: X2_min = 0;
int: X2_max = 100;
int: X3_min = 0;
int: X3_max = 100;

% Costs in tenths of dollars to keep everything integral:
% 0.5 -> 5, 0.3 -> 3, 0.7 -> 7
int: c1 = 5;
int: c2 = 3;
int: c3 = 7;

% Variables
var X1_min..X1_max: X1;
var X2_min..X2_max: X2;
var X3_min..X3_max: X3;

var 0..(c1*X1_max + c2*X2_max + c3*X3_max): total_cost_tenths;

% Constraints
constraint X1 + X2 + X3 <= TOTAL_MAX;

% 2*X1 >= 0.5*X2 + 30  -> multiply by 2: 4*X1 >= X2 + 60
constraint 4*X1 >= X2 + 60;

% X1 - 0.5*X3 <= 20 -> multiply by 2: 2*X1 - X3 <= 40
constraint 2*X1 - X3 <= 40;

constraint total_cost_tenths = c1*X1 + c2*X2 + c3*X3;

% Objective
solve minimize total_cost_tenths;