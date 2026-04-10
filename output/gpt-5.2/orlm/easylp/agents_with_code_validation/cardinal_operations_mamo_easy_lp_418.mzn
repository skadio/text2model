% Parameters
int: power_per_unit_x = 60;          % Power produced per unit allocated to plant X
int: power_per_unit_y = 90;          % Power produced per unit allocated to plant Y

int: coeff_x = 2;                    % Coefficient for X in the combined resource constraint
int: coeff_y = 3;                    % Coefficient for Y in the combined resource constraint
int: max_weighted_allocation = 1200; % Upper bound on 2*X + 3*Y

int: min_total_allocation = 100;     % Lower bound on X + Y


% Variables
var 0..(max_weighted_allocation div coeff_x): x;  % Resource units allocated to plant X (integer, non-negative)
var 0..(max_weighted_allocation div coeff_y): y;  % Resource units allocated to plant Y (integer, non-negative)

% Total power produced; upper bound derived from individual variable bounds
var 0..(power_per_unit_x * (max_weighted_allocation div coeff_x)
      + power_per_unit_y * (max_weighted_allocation div coeff_y)): total_power;


% Constraints
% Weighted resource allocation limit: 2*x + 3*y <= 1200
constraint coeff_x * x + coeff_y * y <= max_weighted_allocation;

% Allocation dominance: plant X allocation must be at least plant Y allocation
constraint x >= y;

% Minimum total allocation requirement: x + y >= 100
constraint x + y >= min_total_allocation;

% Define total power production from allocations
constraint total_power = power_per_unit_x * x + power_per_unit_y * y;


% Objective
solve minimize total_power;