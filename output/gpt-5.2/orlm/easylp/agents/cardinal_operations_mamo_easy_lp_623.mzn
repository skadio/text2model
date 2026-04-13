% Parameters
% Cost coefficients for each process
int: cost_x1 = 4;
int: cost_x2 = 3;
int: cost_x3 = 5;
int: cost_x4 = 6;

% Constraint right-hand sides
int: rhs_x1_x2_max = 1000;           % x1 + x2 <= 1000
int: rhs_2x2_x3_min = 500;           % 2*x2 + x3 >= 500
int: rhs_0_5x3_minus_x1_max = 200;   % 0.5*x3 - x1 <= 200
int: rhs_x4_minus_x2_min = -400;     % x4 - x2 >= -400
int: rhs_0_8x4_minus_x3_max = -300;  % 0.8*x4 - x3 <= -300

% Bounds (interpreted as non-negative allocations)
int: lb = 0;


% Variables
var int: x1; % resource allocation for process X1
var int: x2; % resource allocation for process X2
var int: x3; % resource allocation for process X3
var int: x4; % resource allocation for process X4

% Total cost (objective)
var int: total_cost;


% Constraints

% --- Non-negativity bounds for resource allocations ---
constraint x1 >= lb /\ x2 >= lb /\ x3 >= lb /\ x4 >= lb;

% --- Budget / capacity coupling between X1 and X2 ---
constraint x1 + x2 <= rhs_x1_x2_max;

% --- Minimum operational requirement linking X2 and X3 ---
constraint 2 * x2 + x3 >= rhs_2x2_x3_min;

% --- Linearized constraint for 0.5*x3 - x1 <= 200 (multiply by 2 to avoid fractions) ---
% 0.5*x3 - x1 <= 200  <=>  x3 - 2*x1 <= 400
constraint x3 - 2 * x1 <= 2 * rhs_0_5x3_minus_x1_max;

% --- Difference constraint between X4 and X2 ---
constraint x4 - x2 >= rhs_x4_minus_x2_min;

% --- Linearized constraint for 0.8*x4 - x3 <= -300 (multiply by 10 to avoid decimals) ---
% 0.8*x4 - x3 <= -300  <=>  8*x4 - 10*x3 <= -3000
constraint 8 * x4 - 10 * x3 <= 10 * rhs_0_8x4_minus_x3_max;

% --- Define total cost from process allocations ---
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;


% Objective
solve minimize total_cost;

output [
  "x1=", show(x1), "\n",
  "x2=", show(x2), "\n",
  "x3=", show(x3), "\n",
  "x4=", show(x4), "\n",
  "total_cost=", show(total_cost), "\n"
];