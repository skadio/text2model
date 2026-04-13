% Parameters
int: cost_x1 = 5;                     % Unit cost for project x1
int: cost_x2 = 4;                     % Unit cost for project x2
int: cost_x3 = 3;                     % Unit cost for project x3

int: max_c1 = 1000;                   % RHS for constraint: x1 + 2*x2 <= 1000
int: min_c2 = 500;                    % RHS for constraint: 3*x1 - x2 + x3 >= 500
int: eq_c3  = 200;                    % RHS for constraint: -x1 + 4*x2 - 2*x3 = 200

int: x1_lb = 0; int: x1_ub = 500;     % Bounds for x1
int: x2_lb = 0; int: x2_ub = 300;     % Bounds for x2
int: x3_lb = 0; int: x3_ub = 400;     % Bounds for x3

% Variables
var x1_lb..x1_ub: x1;                 % Allocation to project x1 (integer)
var x2_lb..x2_ub: x2;                 % Allocation to project x2 (integer)
var x3_lb..x3_ub: x3;                 % Allocation to project x3 (integer)

var int: total_cost;                  % Total cost to minimize

% Constraints
% --- Core linear resource/budget constraints ---
constraint
  x1 + 2 * x2 <= max_c1;

constraint
  3 * x1 - x2 + x3 >= min_c2;

constraint
  -x1 + 4 * x2 - 2 * x3 = eq_c3;

% --- Total cost definition (linking variable) ---
constraint
  total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3;

% Objective
solve minimize total_cost;