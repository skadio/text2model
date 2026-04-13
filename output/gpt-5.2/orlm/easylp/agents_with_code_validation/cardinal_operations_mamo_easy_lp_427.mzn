% Parameters (embedded data)
int: capacity = 500;            % Maximum combined cargo capacity
int: min_x = 200;               % Minimum feasible allocation for freight type X
int: min_y = 100;               % Minimum feasible allocation for freight type Y
int: cost_x_tenths = 1;         % 0.1 units per unit X (i.e., 0.05 = 0.5 tenths) -> use 0.1 scaling below
int: cost_y_tenths = 1;         % 0.1 per unit Y (in tenths)
% We'll measure total cost in tenths to avoid float linear constraints:
% 0.05 = 0.5 tenths, so use "5" in hundredths instead.
int: cost_x_hundredths = 5;     % 0.05 = 5 hundredths
int: cost_y_hundredths = 10;    % 0.10 = 10 hundredths

% Decision variables (integers)
var 0..capacity: x;
var 0..capacity: y;

% Total cost in hundredths (integer)
var 0..100000: total_cost_hundredths = cost_x_hundredths * x + cost_y_hundredths * y;

% Constraints
constraint x >= min_x;
constraint y >= min_y;
constraint x + y <= capacity;

% Objective: minimize total cost
solve minimize total_cost_hundredths;

% Output: minimum total cost rounded to one decimal place
% (Convert hundredths -> tenths with rounding: round(h/10) gives tenths)
output [
  "x=", show(x), "\n",
  "y=", show(y), "\n",
  "min_total_cost_1dp=",
  show_float(1, int2float((total_cost_hundredths + 5) div 10) / 10.0), "\n"
];