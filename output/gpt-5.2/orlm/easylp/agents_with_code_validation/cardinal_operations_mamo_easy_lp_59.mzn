% Parameters
% All data is embedded directly in the model (no .dzn expected)

int: min_perf_rhs = 10;        % RHS for minimum performance constraint
int: cap_rhs = 20;             % RHS for capacity constraint

int: perf_x_coeff = 3;         % Coefficient of X in performance constraint
int: perf_y_coeff = 1;         % Coefficient of Y in performance constraint

int: cap_x_coeff = 2;          % Coefficient of X in capacity constraint
int: cap_y_coeff = 4;          % Coefficient of Y in capacity constraint

int: cost_x = 4;               % Cost per unit of Network Upgrade (X)
int: cost_y = 6;               % Cost per unit of Security Enhancement (Y)

% Simple explicit upper bounds derived from the capacity constraint and non-negativity
int: x_ub = cap_rhs div cap_x_coeff;  % max X when Y=0
int: y_ub = cap_rhs div cap_y_coeff;  % max Y when X=0


% Variables
var 0..x_ub: x;                % Resources allocated to Network Upgrade (integer, non-negative)
var 0..y_ub: y;                % Resources allocated to Security Enhancement (integer, non-negative)

var 0..(cost_x * x_ub + cost_y * y_ub): total_cost;  % Total cost (bounded)


% Constraints

% --- Minimum network performance requirement ---
constraint
  perf_x_coeff * x + perf_y_coeff * y >= min_perf_rhs;

% --- Capacity / resource limit requirement ---
constraint
  cap_x_coeff * x + cap_y_coeff * y <= cap_rhs;

% --- Define total cost from allocations ---
constraint
  total_cost = cost_x * x + cost_y * y;


% Objective
solve minimize total_cost;

% Optional output for inspection
output [
  "x = ", show(x), "\n",
  "y = ", show(y), "\n",
  "total_cost = ", show(total_cost), "\n"
];