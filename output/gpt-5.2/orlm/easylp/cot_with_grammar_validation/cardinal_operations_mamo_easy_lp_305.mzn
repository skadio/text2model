% Parameters
int: R_max = 5000;
int: eff_min = 3000;
int: log_max = 2500;

int: c1 = 5;
int: c2 = 3;
int: c3 = 7;

% Variables
var 0..R_max: X1;
var 0..R_max: X2;
var 0..R_max: X3;

var 0..(c1*R_max + c2*R_max + c3*R_max): TotalCost;

% Constraints
constraint X1 + X2 + X3 <= R_max;

constraint 4*X1 + 6*X3 >= eff_min;

% "twice X2 and thrice the half of X3" => 2*X2 + 3*(X3/2) <= 2500
% To keep it linear in integers: 2*X2 + (3*X3) div 2 <= 2500
constraint 2*X2 + (3*X3) div 2 <= log_max;

constraint TotalCost = c1*X1 + c2*X2 + c3*X3;

% Objective
solve minimize TotalCost;