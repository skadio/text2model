% Parameters (with values embedded)
int: n = 4;
set of int: P = 1..n;

% Unit costs for X1..X4
array[P] of int: cost = [5, 10, 20, 25];

% Upper bounds (not explicitly provided in the description; use safe capacity-based bounds)
% From constraints: X1+X2 <= 100 => X1,X2 <= 100
% Also a max limit of 200 units for X4 (and related to X3 via ratio), so X3 <= 200, X4 <= 200
array[P] of int: ub = [100, 100, 200, 200];

% Variables
array[P] of var 0..max(ub): x;  % x[1]=X1, x[2]=X2, x[3]=X3, x[4]=X4

% Constraints
constraint forall(i in P) (x[i] <= ub[i]);

% 1) X1 + X2 <= 100
constraint x[1] + x[2] <= 100;

% 2) For every 2 units of X3, 3 units of X4 can be made, within a max limit of 200 units (on X4).
% Enforce exact ratio: 2*X4 = 3*X3, and X4 <= 200 already enforced by ub.
constraint 2 * x[4] = 3 * x[3];

% 3) X1 - 2*X2 + X3 >= 50
constraint x[1] - 2 * x[2] + x[3] >= 50;

% 4) X1 - (X2 - X3) <= 70  i.e., X1 - X2 + X3 <= 70
constraint x[1] - x[2] + x[3] <= 70;

% Objective
var int: total_cost = sum(i in P)(cost[i] * x[i]);
solve minimize total_cost;