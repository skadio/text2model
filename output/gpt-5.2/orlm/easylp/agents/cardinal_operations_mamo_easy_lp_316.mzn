% Parameters
int: max_total_allocation = 1000;        % Upper bound on X+Y+Z
int: min_strength_xy = 400;              % Lower bound on 2*X + Y
int: max_allocation_yz = 600;            % Upper bound on Y+Z

int: cost_x = 4;                         % Cost per unit of X
int: cost_y = 3;                         % Cost per unit of Y
int: cost_z = 5;                         % Cost per unit of Z

% Variables
var 0..max_total_allocation: x;          % Allocation to unit X (integer, non-negative)
var 0..max_total_allocation: y;          % Allocation to unit Y (integer, non-negative)
var 0..max_total_allocation: z;          % Allocation to unit Z (integer, non-negative)

var 0..(cost_x*max_total_allocation + cost_y*max_total_allocation + cost_z*max_total_allocation): total_cost;
                                         % Total cost (bounded linear expression)

% Constraints
% Total allocation limit across all units
constraint
  x + y + z <= max_total_allocation;

% Minimum combined strength requirement for units X and Y: 2*X + Y >= threshold
constraint
  2 * x + y >= min_strength_xy;

% Balanced deployment constraint: allocation to Y and Z cannot exceed limit
constraint
  y + z <= max_allocation_yz;

% Define total cost as the linear cost of allocations
constraint
  total_cost = cost_x * x + cost_y * y + cost_z * z;

% Objective
solve minimize total_cost;