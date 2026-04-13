% Parameters
% Number of departments
int: n = 4;

% Unit costs for each department x1..x4
array[1..n] of int: cost = [2, 3, 4, 5];

% Constraint bounds
int: max_x1_x2 = 1000;      % x1 + x2 <= 1000
int: min_x3_x4 = 500;       % x3 + x4 >= 500
int: balance_rhs = 300;     % for: 2*x1 - (x3/2) >= -300 (handled without fractions)
int: max_diff = 400;        % (x1 + x2) - x4 <= 400

% Variable bounds (non-negative allocations; generic safe upper bounds embedded)
array[1..n] of int: lb = [0, 0, 0, 0];
array[1..n] of int: ub = [1000, 1000, 10000, 10000];

% Variables
% Resource allocations per department (x[1]=x1,...,x[4]=x4)
array[1..n] of var int: x;

% Total cost
var int: total_cost;

% Constraints
% Bound constraints for each department
constraint forall(i in 1..n) (x[i] >= lb[i] /\ x[i] <= ub[i]);

% Define total cost
constraint total_cost = sum(i in 1..n)(cost[i] * x[i]);

% --- Budget/Capacity constraint on departments 1 and 2 ---
% x1 + x2 <= 1000
constraint x[1] + x[2] <= max_x1_x2;

% --- Minimum allocation constraint on departments 3 and 4 ---
% x3 + x4 >= 500
constraint x[3] + x[4] >= min_x3_x4;

% --- Balance constraint between departments 1 and 3 (avoid fractions) ---
% Original: 2*x1 - (x3/2) >= -300
% Multiply by 2: 4*x1 - x3 >= -600
constraint 4 * x[1] - x[3] >= -2 * balance_rhs;

% --- Difference/balance constraint involving departments 1,2,4 ---
% (x1 + x2) - x4 <= 400
constraint (x[1] + x[2]) - x[4] <= max_diff;

% Objective
solve minimize total_cost;