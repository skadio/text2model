% Parameters
int: max_total_units = 5000;

int: costX = 5;
int: costY = 10;
int: costZ = 20;

int: extra_X_over_halfY = 1000;

int: z_extra_over_75pctX = 1500;
int: z_num = 3;
int: z_den = 4; % 75% = 3/4

% Variables
var 0..max_total_units: X;
var 0..max_total_units: Y;
var 0..max_total_units: Z;

var 0..(costX*max_total_units + costY*max_total_units + costZ*max_total_units): total_cost;

% Constraints
constraint X + Y + Z <= max_total_units;

% X >= 1000 + 0.5*Y  <=>  2*X >= 2*1000 + Y
constraint 2*X >= 2*extra_X_over_halfY + Y;

% Z - (3/4)*X <= 1500  <=>  4*Z - 3*X <= 4*1500
constraint z_den*Z - z_num*X <= z_den*z_extra_over_75pctX;

constraint total_cost = costX*X + costY*Y + costZ*Z;

% Objective
solve minimize total_cost;