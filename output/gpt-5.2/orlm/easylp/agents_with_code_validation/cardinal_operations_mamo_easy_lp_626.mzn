% Parameters
% All data is embedded directly in the model as per instructions.

int: max_x1_x2 = 50;              % Upper bound for X1 + X2
int: max_x3_x4 = 70;              % Upper bound for X3 + X4
int: min_x1_minus_2x3 = 10;       % Lower bound for X1 - 2*X3
int: max_x2_minus_2x4 = 20;       % Upper bound for X2 - 2*X4

int: cost_x1 = 5000;              % Cost per unit of X1
int: cost_x2 = 6000;              % Cost per unit of X2
int: cost_x3 = 7000;              % Cost per unit of X3
int: cost_x4 = 8000;              % Cost per unit of X4


% Variables
var 0..max_x1_x2: x1;             % Allocation to initiative X1 (whole units)
var 0..max_x1_x2: x2;             % Allocation to initiative X2 (whole units)
var 0..max_x3_x4: x3;             % Allocation to initiative X3 (whole units)
var 0..max_x3_x4: x4;             % Allocation to initiative X4 (whole units)

% Total cost (bounded using max possible allocations under given caps)
var 0..(max_x1_x2*cost_x1 + max_x1_x2*cost_x2 + max_x3_x4*cost_x3 + max_x3_x4*cost_x4): total_cost;


% Constraints

% --- Budget cap constraints on paired initiatives ---
constraint x1 + x2 <= max_x1_x2;   % Combined allocation for X1 and X2 cannot exceed max_x1_x2
constraint x3 + x4 <= max_x3_x4;   % Combined allocation for X3 and X4 cannot exceed max_x3_x4

% --- Strategic balance constraints between initiatives ---
constraint x1 - 2 * x3 >= min_x1_minus_2x3;  % Enforce minimum difference between X1 and twice X3
constraint x2 - 2 * x4 <= max_x2_minus_2x4;  % Limit X2 after subtracting twice X4

% --- Total cost accounting constraint ---
constraint total_cost = cost_x1 * x1 + cost_x2 * x2 + cost_x3 * x3 + cost_x4 * x4;


% Objective
solve minimize total_cost;