% Freight car relocation among 5 regions
% Minimize total relocation cost so that each region meets its required cars.
% Data embedded directly.

int: N = 5;
set of int: R = 1..N;

array[R] of int: supply = [115, 385, 410, 480, 610];
array[R] of int: demand = [200, 500, 800, 200, 300];

% Cost matrix (cost[i,i]=0; costs given for i!=i)
array[R, R] of int: cost =
[
|  0, 10, 12, 17, 34
| 10,  0, 18,  8, 46
| 12, 18,  0,  9, 27
| 17,  8,  9,  0, 20
| 34, 46, 27, 20,  0
];

% Feasibility check: total supply must cover total demand
constraint sum(r in R)(supply[r]) >= sum(r in R)(demand[r]);

% x[i,j] = number of cars moved from region i to region j (i != j)
array[R, R] of var 0..max(supply): x;

% No self-moves
constraint forall(i in R)(x[i,i] = 0);

% Flow balance:
% final_cars[r] = supply[r] - outgoing[r] + incoming[r] >= demand[r]
constraint forall(r in R)(
    supply[r]
    - sum(j in R where j != r)(x[r,j])
    + sum(i in R where i != r)(x[i,r])
    >= demand[r]
);

% Cannot ship out more than available supply in any region
constraint forall(i in R)(
    sum(j in R where j != i)(x[i,j]) <= supply[i]
);

var int: total_cost = sum(i in R, j in R)(cost[i,j] * x[i,j]);

solve minimize total_cost;

% Output: total cost (already integer units; "rounded to nearest dollar" is itself)
output [
  "Minimum total cost (rounded to nearest dollar): ", show(total_cost), "\n",
  "Shipment matrix x[i,j] (cars moved from i to j):\n"
] ++
[
  if i = 1 then "" else "" endif ++
  concat([ show(x[i,j]) ++ if j < N then "\t" else "\n" endif | j in R ])
  | i in R
];