% Parameters
int: coeff_log_x = 10;              % Logistical coefficient for X in capacity constraint
int: coeff_log_y = 20;              % Logistical coefficient for Y in capacity constraint
int: rhs_log = 3000;                % Maximum logistical capacity

int: coeff_str_x = 3;               % Strength coefficient for X in minimum strength constraint
int: coeff_str_y = 5;               % Strength coefficient for Y in minimum strength constraint
int: rhs_str = 500;                 % Minimum required strength

int: max_diff = 1000;               % Maximum allowed absolute difference |X - Y|

int: cost_x = 10000;                % Cost (support points) per unit of X in dollars
int: cost_y = 20000;                % Cost (support points) per unit of Y in dollars

% Derived bounds for decision variables from logistical constraint (non-negativity implied)
int: x_ub = rhs_log div coeff_log_x; % Max X if Y=0
int: y_ub = rhs_log div coeff_log_y; % Max Y if X=0

% Variables
var 0..x_ub: x_units;               % Number of units allocated to type X (integer, non-negative)
var 0..y_ub: y_units;               % Number of units allocated to type Y (integer, non-negative)

var 0..(cost_x * x_ub + cost_y * y_ub): total_cost;  % Total support cost in dollars (integer)

% Constraints

% --- Logistical capacity constraint: 10*X + 20*Y <= 3000
constraint
  coeff_log_x * x_units + coeff_log_y * y_units <= rhs_log;

% --- Minimum strength requirement: 3*X + 5*Y >= 500
constraint
  coeff_str_x * x_units + coeff_str_y * y_units >= rhs_str;

% --- Balance constraint: |X - Y| <= 1000
constraint
  abs(x_units - y_units) <= max_diff;

% --- Define total cost from unit costs
constraint
  total_cost = cost_x * x_units + cost_y * y_units;

% Objective
solve minimize total_cost;

% (Optional) Output for convenience
output [
  "x_units=", show(x_units), "\n",
  "y_units=", show(y_units), "\n",
  "total_cost=$", show(total_cost), "\n"
];