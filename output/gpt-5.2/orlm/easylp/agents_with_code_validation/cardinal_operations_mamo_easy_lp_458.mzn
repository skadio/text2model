% Parameters
int: units_per_hour_X = 5000;                 % Resource units consumed per hour for Project X
int: units_per_hour_Y = 3000;                 % Resource units consumed per hour for Project Y

int: max_total_hours = 20;                    % Max combined hours available

int: x_min = 0;                               % Lower bound hours for Project X
int: x_max = 15;                              % Upper bound hours for Project X
int: y_min = 0;                               % Lower bound hours for Project Y
int: y_max = 10;                              % Upper bound hours for Project Y

int: min_expr_rhs = 5;                        % RHS for 3*x - 4*y >= 5
int: eq_expr_rhs = 10;                        % RHS for 2*x + y == 10

% Variables
var x_min..x_max: hours_X;                    % Integer hours allocated to Project X
var y_min..y_max: hours_Y;                    % Integer hours allocated to Project Y

var 0..(units_per_hour_X * x_max + units_per_hour_Y * y_max): total_units;
                                               % Total resource units (objective)

% Constraints
% --- Total available hours constraint (combined allocation limit) ---
constraint
  hours_X + hours_Y <= max_total_hours;

% --- Strategic requirement: 3*X - 4*Y must be at least the given threshold ---
constraint
  3 * hours_X - 4 * hours_Y >= min_expr_rhs;

% --- Exact workload balance: 2*X + Y must equal the given target ---
constraint
  2 * hours_X + hours_Y == eq_expr_rhs;

% --- Define total resource units consumed based on allocated hours ---
constraint
  total_units = units_per_hour_X * hours_X + units_per_hour_Y * hours_Y;

% Objective
solve minimize total_units;