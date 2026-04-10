% Parameters
int: total_budget_limit = 5000;

int: costX = 10;
int: costY = 20;
int: costZ = 30;

int: eff_coeff_X = 5;
int: eff_coeff_Y = 10;
int: eff_min = 10000;

int: diff_limit = 1500;

% Variables
var 0..total_budget_limit: X;  % dollars allocated to department X
var 0..total_budget_limit: Y;  % dollars allocated to department Y
var 0..total_budget_limit: Z;  % dollars allocated to department Z

var 0..(costX*total_budget_limit + costY*total_budget_limit + costZ*total_budget_limit): total_cost;

% Constraints
constraint X + Y + Z <= total_budget_limit;

constraint eff_coeff_X * X + eff_coeff_Y * Y >= eff_min;

constraint abs(X - Z) <= diff_limit;

constraint total_cost = costX * X + costY * Y + costZ * Z;

% Objective
solve minimize total_cost;