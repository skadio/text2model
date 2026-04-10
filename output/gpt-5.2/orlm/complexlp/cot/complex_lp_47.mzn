% Parameters (with values embedded)
int: N = 6;
set of int: R = 1..N;

array[R] of int: stock  = [319, 281, 247, 237, 29, 453];
array[R] of int: need   = [243, 243, 124, 202, 84, 28];

% cost[i,j] = cost to ship 1 unit from region i to region j
array[R, R] of int: cost =
[
|  0, 11, 30, 12, 48, 23
|  1,  0, 27,  9, 26, 13
| 29,  6,  0, 27, 13, 44
|  6, 50, 12,  0, 19, 32
| 26, 13, 29,  2,  0, 24
|  9, 26,  2, 37, 22,  0
];

int: total_stock = sum(r in R)(stock[r]);
int: total_need  = sum(r in R)(need[r]);

% Variables
int: max_ship = total_stock; % safe upper bound
array[R, R] of var 0..max_ship: x; % x[i,j] shipped from i to j (including i=j allowed)

% Constraints
constraint total_stock = total_need; % feasibility check (should hold)

% No self-shipping (optional but tightens model)
constraint forall(i in R)(x[i,i] = 0);

% Flow balance: final amount in each region equals need
% final[r] = stock[r] - outflow[r] + inflow[r] = need[r]
constraint
  forall(r in R)(
    stock[r]
    - sum(j in R)(x[r,j])
    + sum(i in R)(x[i,r])
    = need[r]
  );

% Objective
var int: total_cost = sum(i in R, j in R)(cost[i,j] * x[i,j]);
solve minimize total_cost;

output [
  "Minimum cost = ", show(total_cost), "\n",
  "Shipments x[i,j]:\n"
] ++
[
  if i=1 then "" else "" endif ++
  concat([ if j=1 then "" else "" endif ++ show(x[i,j]) ++ if j<N then " " else "\n" endif | j in R ])
  | i in R
];