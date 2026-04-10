% Parameters
% Minimum total resources required
int: min_total_resources = 50;

% Constraint coefficients and RHS:
% 4*X - 1*Y <= 30
int: c1_x = 4;
int: c1_y = -1;
int: c1_rhs = 30;

% 1*Z - 2*Y >= 10
int: c2_z = 1;
int: c2_y = -2;
int: c2_rhs = 10;

% Unit costs
int: cost_x = 5;
int: cost_y = 3;
int: cost_z = 2;

% Variables
% Integer resource allocations for each department (non-negative)
var 0..1000: x; % resources allocated to department X
var 0..1000: y; % resources allocated to department Y
var 0..1000: z; % resources allocated to department Z

% Total cost (bounded for safety in linear expressions)
var 0..(cost_x*1000 + cost_y*1000 + cost_z*1000): total_cost;

% Constraints
% Total resources requirement (at least the minimum required)
constraint
  x + y + z >= min_total_resources;

% Linear constraint 1: 4*X - Y <= 30 (using provided coefficients)
constraint
  c1_x * x + c1_y * y <= c1_rhs;

% Linear constraint 2: Z - 2*Y >= 10 (using provided coefficients)
constraint
  c2_z * z + c2_y * y >= c2_rhs;

% Total cost definition (linking total_cost to allocations and unit costs)
constraint
  total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;