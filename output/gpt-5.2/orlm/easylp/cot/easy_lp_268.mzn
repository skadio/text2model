% Parameters (with values embedded)
int: max_total_employees = 100;

int: cost_X = 5000;
int: cost_Y = 4000;
int: cost_Z = 6000;

int: z_extra_cap = 10;

% Variables
var 0..max_total_employees: X;
var 0..max_total_employees: Y;
var 0..max_total_employees: Z;

var 0..(cost_X*max_total_employees + cost_Y*max_total_employees + cost_Z*max_total_employees): total_cost;

% Constraints
constraint X + Y + Z <= max_total_employees;

% "X at least twice the half of Y" -> X >= 2*(Y/2) = Y
constraint X >= Y;

% "Z should not exceed by more than 10 the three-fourths of X"
% Z <= (3/4)X + 10  -> 4Z <= 3X + 40
constraint 4*Z <= 3*X + 4*z_extra_cap;

constraint total_cost = cost_X*X + cost_Y*Y + cost_Z*Z;

% Objective
solve minimize total_cost;