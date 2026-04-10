% Parameters
% Power produced per unit of resource allocated to each plant
int: power_per_unit_X = 60;
int: power_per_unit_Y = 90;

% Capacity coefficients and limit for the main constraint: 2*X + 3*Y <= 1200
int: coeff_X = 2;
int: coeff_Y = 3;
int: capacity_limit = 1200;

% Minimum total allocation constraint: X + Y >= 100
int: min_total_allocation = 100;

% Variables
% Resource allocation units (must be whole numbers, non-negative)
var 0..(capacity_limit div coeff_X): x_units;  % allocation to plant X
var 0..(capacity_limit div coeff_Y): y_units;  % allocation to plant Y

% Total power production (bounded for linear modeling convenience)
var 0..(power_per_unit_X * (capacity_limit div coeff_X)
      + power_per_unit_Y * (capacity_limit div coeff_Y)): total_power;

% Constraints
% Capacity constraint: weighted total allocation must not exceed the limit
constraint
  coeff_X * x_units + coeff_Y * y_units <= capacity_limit;

% Dominance constraint: allocation to plant X must be at least that of plant Y
constraint
  x_units >= y_units;

% Minimum total allocation constraint: ensure enough total resources are allocated
constraint
  x_units + y_units >= min_total_allocation;

% Definition constraint: compute total power from allocations
constraint
  total_power = power_per_unit_X * x_units + power_per_unit_Y * y_units;

% Objective
solve minimize total_power;