% Parameters (with values embedded)
int: N = 4;
set of int: I = 1..N;

% Costs per unit for initiatives X1..X4 (in dollars)
array[I] of int: cost = [5000, 6000, 7000, 8000];

% Variables
% x[1]=X1, x[2]=X2, x[3]=X3, x[4]=X4
array[I] of var int: x;

% Constraints
% Non-negativity (allocations are whole numbers)
constraint forall(i in I)(x[i] >= 0);

% X1 + X2 <= 50
constraint x[1] + x[2] <= 50;

% X3 + X4 <= 70
constraint x[3] + x[4] <= 70;

% X1 - 2*X3 >= 10
constraint x[1] - 2 * x[3] >= 10;

% X2 - 2*X4 <= 20
constraint x[2] - 2 * x[4] <= 20;

% Objective
var int: total_cost = sum(i in I)(cost[i] * x[i]);
solve minimize total_cost;