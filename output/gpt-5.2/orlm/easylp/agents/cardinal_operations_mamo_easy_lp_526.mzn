% Parameters
int: total_allocation_max = 5000;              % Total allocation upper bound across all departments
int: min_effectiveness = 2000;                 % Minimum required effectiveness score
int: balance_diff_max = 100;                   % Max allowed absolute deviation in balance constraint

int: x1_min = 0;  int: x1_max = 3000;          % Bounds for department X1
int: x2_min = 0;  int: x2_max = 2500;          % Bounds for department X2
int: x3_min = 0;  int: x3_max = 1500;          % Bounds for department X3

int: cost_x1 = 50;                             % Cost per unit for X1
int: cost_x2 = 75;                             % Cost per unit for X2
int: cost_x3 = 60;                             % Cost per unit for X3

% Effectiveness weights as integer-scaled (to avoid floats): 0.5, 0.4, 0.6 -> 5/10, 4/10, 6/10
int: eff_scale = 10;                           % Scaling factor for effectiveness computation
int: eff_w1 = 5;                               % Scaled effectiveness weight for X1
int: eff_w2 = 4;                               % Scaled effectiveness weight for X2
int: eff_w3 = 6;                               % Scaled effectiveness weight for X3


% Variables
var x1_min..x1_max: x1;                        % Allocation (integer units) to department X1
var x2_min..x2_max: x2;                        % Allocation (integer units) to department X2
var x3_min..x3_max: x3;                        % Allocation (integer units) to department X3

var 0..(cost_x1*x1_max + cost_x2*x2_max + cost_x3*x3_max): total_cost;   % Total cost to minimize

% Helper for balance constraint (explicit bounded variable)
var -balance_diff_max..balance_diff_max: balance_diff;  % 2*X2 - (X1 + X3), bounded by +/- 100


% Constraints
% Total allocation budget constraint: X1 + X2 + X3 <= 5000
constraint
  x1 + x2 + x3 <= total_allocation_max;

% Minimum effectiveness constraint (scaled to avoid floats):
% (0.5*x1 + 0.4*x2 + 0.6*x3) >= 2000  <=>  (5*x1 + 4*x2 + 6*x3) >= 2000*10
constraint
  eff_w1 * x1 + eff_w2 * x2 + eff_w3 * x3 >= min_effectiveness * eff_scale;

% Balance constraint: difference between 2*X2 and (X1 + X3) within +/- 100
constraint
  balance_diff = 2 * x2 - (x1 + x3);

% Total cost definition (kept integral)
constraint
  total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3;


% Objective
solve minimize total_cost;