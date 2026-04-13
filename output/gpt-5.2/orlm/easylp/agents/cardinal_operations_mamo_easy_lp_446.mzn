% Parameters
int: cost_x = 20;                 % Cost per unit allocated to Project X ($/unit)
int: cost_y = 30;                 % Cost per unit allocated to Project Y ($/unit)

int: min_progress = 60;           % Minimum required progress units
int: max_workload = 80;           % Maximum allowed workload units

int: x_y_diff_min = 10;           % Minimum difference X - Y (in favor of X)

int: x_lb = 0;                    % Lower bound for X allocation
int: x_ub = 1000;                 % Upper bound for X allocation
int: y_lb = 0;                    % Lower bound for Y allocation
int: y_ub = 500;                  % Upper bound for Y allocation

% Variables
var x_lb..x_ub: x_units;          % Integer resource units allocated to Project X
var y_lb..y_ub: y_units;          % Integer resource units allocated to Project Y

var int: total_cost;              % Total cost ($), integer valued

% Constraints
% Progress requirement: ensure sufficient progress from combined allocations
constraint 5 * x_units + 3 * y_units >= min_progress;

% Workload cap: avoid exceeding maximum allowable workload
constraint 4 * x_units + y_units <= max_workload;

% Strategic focus: allocate at least x_y_diff_min more units to X than Y
constraint x_units - y_units >= x_y_diff_min;

% Total cost definition: compute total cost from unit costs and allocations
constraint total_cost = cost_x * x_units + cost_y * y_units;

% Objective
solve minimize total_cost;

output [
  "x_units=", show(x_units), "\n",
  "y_units=", show(y_units), "\n",
  "total_cost=", show(total_cost), "\n"
];