% Parameters (with values embedded)
int: n = 4;
array[1..n] of int: cost = [5, 3, 2, 7];

int: idx_x1 = 1;
int: idx_x2 = 2;
int: idx_x3 = 3;
int: idx_x4 = 4;

% NOTE: The problem statement mentions "specific bounds" but does not provide them.
% We assume non-negativity bounds (common for allocations).
int: UB = 1000000; % large upper bound to keep variables bounded

% Variables
array[1..n] of var 0..UB: x;

% Constraints
constraint 2 * x[idx_x1] + 3 * x[idx_x2] <= 150;
constraint x[idx_x1] + x[idx_x4] >= 30;
constraint abs(x[idx_x3] - x[idx_x4]) <= 10;
constraint 4 * x[idx_x1] + 5 * x[idx_x2] + x[idx_x3] >= 80;

% Objective
var int: total_cost = sum(i in 1..n)(cost[i] * x[i]);
solve minimize total_cost;