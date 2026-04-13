% Parameters
int: min_total_shifts = 10;          % Minimum total number of shifts required
int: max_excess_x_over_2y = 4;       % X cannot exceed 2*Y by more than this amount
int: cost_per_shift_x = 8;           % Wage cost per X shift
int: cost_per_shift_y = 5;           % Wage cost per Y shift

% Variables
var 0..min_total_shifts: shifts_x;   % Number of shifts assigned to type X workers
var 0..min_total_shifts: shifts_y;   % Number of shifts assigned to type Y workers
var 0..(cost_per_shift_x*min_total_shifts + cost_per_shift_y*min_total_shifts): total_cost; % Total wage cost

% Constraints
% Ensure the minimum total number of shifts is covered
constraint
  shifts_x + shifts_y >= min_total_shifts;

% Balance constraint: X cannot exceed 2*Y by more than the allowed excess
constraint
  shifts_x - 2 * shifts_y <= max_excess_x_over_2y;

% Define total wage cost from shifts and per-shift costs
constraint
  total_cost = cost_per_shift_x * shifts_x + cost_per_shift_y * shifts_y;

% Objective
solve minimize total_cost;

% Optional output for inspection
output [
  "shifts_x = ", show(shifts_x), "\n",
  "shifts_y = ", show(shifts_y), "\n",
  "total_cost = ", show(total_cost), "\n"
];