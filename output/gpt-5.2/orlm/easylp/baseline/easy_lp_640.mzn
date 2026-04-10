% Environmental resource allocation - all data embedded

int: n = 4;
set of int: P = 1..n;

% Decision variables: integer allocations for X1..X4
array[P] of var int: x;

% Bounds (X1, X2, X3, X4)
array[P] of int: lb = [100, 50, 20, 40];
array[P] of int: ub = [800, 600, 400, 200];

constraint forall(i in P)(lb[i] <= x[i] /\ x[i] <= ub[i]);

var int: X1 = x[1];
var int: X2 = x[2];
var int: X3 = x[3];
var int: X4 = x[4];

% Costs per unit (2,3,4,5)
array[P] of int: cost = [2, 3, 4, 5];

% Constraints (scaled to avoid floating point)
% 1) 2*X2 - X1 - X3 + X4 >= 1000
constraint 2*X2 - X1 - X3 + X4 >= 1000;

% 2) X1 + X3 <= 0.5*X2 + 0.7*X4 + 500
% Multiply by 10: 10X1 + 10X3 <= 5X2 + 7X4 + 5000
constraint 10*X1 + 10*X3 <= 5*X2 + 7*X4 + 5000;

% 3) 0.8*X1 + 1.0*X3 - 0.9*X2 <= 1500
% Multiply by 10: 8X1 + 10X3 - 9X2 <= 15000
constraint 8*X1 + 10*X3 - 9*X2 <= 15000;

% 4) X1 + X2 + X3 + X4 >= 200
constraint X1 + X2 + X3 + X4 >= 200;

% 5) (X1 + X3) - (3/5)*X2 <= 300   (interpreting "difference ... cannot exceed 300" as an upper bound)
% Multiply by 5: 5X1 + 5X3 - 3X2 <= 1500
constraint 5*X1 + 5*X3 - 3*X2 <= 1500;

% Objective: minimize total cost
var int: total_cost = sum(i in P)(cost[i] * x[i]);
solve minimize total_cost;

output [
  "X1=", show(X1), "\n",
  "X2=", show(X2), "\n",
  "X3=", show(X3), "\n",
  "X4=", show(X4), "\n",
  "total_cost=", show(total_cost), "\n",
  "rounded_total_cost=", show(total_cost), "\n"
];