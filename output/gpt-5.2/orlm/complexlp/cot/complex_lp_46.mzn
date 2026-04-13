% Parameters (with values embedded)
int: N = 7;
set of int: H = 1..N;

array[H] of int: stock = [160, 353, 171, 193, 102, 429, 284];
array[H] of int: need  = [ 19, 138, 110, 446, 341, 428,  47];

% cost[i,j] is cost to ship 1 unit from hospital i to hospital j; cost[i,i]=0
array[H,H] of int: cost =
[
| 0, 12, 47, 39,  4, 21, 31
|14,  0, 39, 12, 31, 29, 15
|15,  6,  0, 26, 12,  5,  3
|39, 47, 42,  0, 33, 48,  2
|35, 25, 46, 12,  0, 25, 45
|39, 28, 28, 11, 16,  0, 13
|42, 43, 49, 41, 41, 18,  0
];

% total supply/demand check is not required but helps understand feasibility
int: total_stock = sum(h in H)(stock[h]);
int: total_need  = sum(h in H)(need[h]);

% Variables
% x[i,j] = units shipped from i to j (nonnegative integer)
array[H,H] of var 0..total_stock: x;

% Constraints
% Do not ship from a hospital to itself
constraint forall(i in H)( x[i,i] = 0 );

% Flow balance: final inventory at each hospital must be >= need[h]
% final[h] = stock[h] + inflow - outflow
constraint forall(h in H)(
  stock[h] + sum(i in H)(x[i,h]) - sum(j in H)(x[h,j]) >= need[h]
);

% A hospital cannot ship more than it has after receiving inflow (enforced by balance plus nonnegativity),
% but we can also enforce that outflow cannot exceed stock + inflow to avoid negative final explicitly:
constraint forall(h in H)(
  sum(j in H)(x[h,j]) <= stock[h] + sum(i in H)(x[i,h])
);

% Objective
var int: total_cost = sum(i in H, j in H)(cost[i,j] * x[i,j]);
solve minimize total_cost;

output [
  "Minimum total cost = ", show(total_cost), "\n",
  "Total stock = ", show(total_stock), ", total need = ", show(total_need), "\n"
];