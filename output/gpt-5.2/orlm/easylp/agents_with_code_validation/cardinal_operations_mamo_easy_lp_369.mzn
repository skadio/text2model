% Parameters
% Project indices
set of int: PROJECTS = 1..4;

% Unit costs for projects X1..X4
array[PROJECTS] of int: unit_cost = [150, 200, 300, 400];

% Capacity limits
int: cap_x1_x2 = 1000;   % X1 + X2 <= 1000
int: cap_x3_x4 = 500;    % X3 + X4 <= 500

% Effectiveness requirements
int: req_eff_12 = 1200;  % 2*X1 + 3*X2 >= 1200
int: req_eff_34 = 2500;  % 5*X3 + 6*X4 >= 2500

% Coefficients for effectiveness constraints (aligned with PROJECTS)
array[PROJECTS] of int: eff_coeff_12 = [2, 3, 0, 0];
array[PROJECTS] of int: eff_coeff_34 = [0, 0, 5, 6];

% Derived integer upper bounds for allocations from capacity limits
int: ub_x1 = cap_x1_x2;
int: ub_x2 = cap_x1_x2;
int: ub_x3 = cap_x3_x4;
int: ub_x4 = cap_x3_x4;

% Variables
% Integer allocations (units) for each project X1..X4
array[PROJECTS] of var int: x;

% Total cost to minimize
var int: total_cost;

% Constraints
% Bounds (kept as constraints to avoid type issues in array declaration)
constraint x[1] >= 0 /\ x[1] <= ub_x1;
constraint x[2] >= 0 /\ x[2] <= ub_x2;
constraint x[3] >= 0 /\ x[3] <= ub_x3;
constraint x[4] >= 0 /\ x[4] <= ub_x4;

% Link total cost
constraint total_cost = sum(p in PROJECTS)(unit_cost[p] * x[p]);

% Capacity constraints for resource-limited project groups
constraint x[1] + x[2] <= cap_x1_x2;   % X1 + X2 <= 1000
constraint x[3] + x[4] <= cap_x3_x4;   % X3 + X4 <= 500

% Effectiveness constraints to meet strategic objectives
constraint sum(p in PROJECTS)(eff_coeff_12[p] * x[p]) >= req_eff_12;  % 2*X1 + 3*X2 >= 1200
constraint sum(p in PROJECTS)(eff_coeff_34[p] * x[p]) >= req_eff_34;  % 5*X3 + 6*X4 >= 2500

% Objective
solve minimize total_cost;

% Optional output
output [
  "x1=", show(x[1]), " x2=", show(x[2]), " x3=", show(x[3]), " x4=", show(x[4]), "\n",
  "total_cost=", show(total_cost), "\n"
];