% Parameters
int: max_total_resources = 200;          % Maximum total resources available (budget cap)
int: perf_coeff_x = 3;                  % Performance coefficient for service X
int: perf_coeff_y = 2;                  % Performance coefficient for service Y
int: min_performance = 400;             % Minimum required performance score
int: min_difference_xy = 50;            % Minimum required difference X - Y
int: cost_per_unit_x = 500;             % Cost per unit resource for X (dollars)
int: cost_per_unit_y = 300;             % Cost per unit resource for Y (dollars)

% Variables
var 0..max_total_resources: x;          % Resources allocated to service X (integer, nonnegative)
var 0..max_total_resources: y;          % Resources allocated to service Y (integer, nonnegative)
var 0..(cost_per_unit_x*max_total_resources + cost_per_unit_y*max_total_resources): total_cost;
                                        % Total cost (dollars)

% Constraints
% Resource budget cap: total allocated resources cannot exceed the maximum available
constraint x + y <= max_total_resources;

% Minimum performance requirement: 3*x + 2*y must reach at least the target score
constraint perf_coeff_x * x + perf_coeff_y * y >= min_performance;

% Portfolio balance requirement: X must exceed Y by at least the specified difference
constraint x - y >= min_difference_xy;

% Total cost definition: link total_cost to decision variables x and y
constraint total_cost = cost_per_unit_x * x + cost_per_unit_y * y;

% Objective
solve minimize total_cost;