% Parameters
int: units_per_hour_x = 5000;          % Resource units required per hour for Project X
int: units_per_hour_y = 3000;          % Resource units required per hour for Project Y

int: max_total_hours = 20;             % Total available hours for both projects combined
int: min_expr_rhs = 5;                 % RHS for 3*x - 4*y >= 5
int: exact_expr_rhs = 10;              % RHS for 2*x + y == 10

int: x_lb = 0;                         % Lower bound for hours on Project X
int: x_ub = 15;                        % Upper bound for hours on Project X
int: y_lb = 0;                         % Lower bound for hours on Project Y
int: y_ub = 10;                        % Upper bound for hours on Project Y

% Derived bound for total units (safe upper bound)
int: max_total_units = max_total_hours * max(units_per_hour_x, units_per_hour_y);

% Variables
var x_lb..x_ub: hours_x;               % Integer hours allocated to Project X
var y_lb..y_ub: hours_y;               % Integer hours allocated to Project Y

var 0..max_total_hours: total_hours;   % Total hours allocated (bounded by availability)
var 0..max_total_units: total_units;   % Total resource units required for both projects

% Constraints
% Link total_hours to decision variables and enforce overall availability
constraint
  total_hours = hours_x + hours_y /\
  total_hours <= max_total_hours;

% Strategic inequality constraint: 3*x - 4*y >= 5
constraint
  3 * hours_x - 4 * hours_y >= min_expr_rhs;

% Exact workload balance constraint: 2*x + y == 10
constraint
  2 * hours_x + hours_y = exact_expr_rhs;

% Link total_units to hours allocated and per-hour unit requirements
constraint
  total_units = units_per_hour_x * hours_x + units_per_hour_y * hours_y;

% Objective
solve minimize total_units;