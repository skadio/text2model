% Freight car relocation among 5 regions (transportation problem)
% Data embedded directly in the model.

int: N = 5;
set of int: R = 1..N;

array[R] of int: supply = [115, 385, 410, 480, 610];
array[R] of int: demand = [300, 400, 800, 200, 300];

% Cost matrix (cost[i,j] = cost to move one car from region i to region j)
% No moves from a region to itself; set to 0 and constrain flow[i,i] = 0.
array[R,R] of int: cost =
[
  [0, 10, 12, 17, 34],
  [10, 0, 18, 8, 46],
  [12, 18, 0, 9, 27],
  [17, 8, 9, 0, 20],
  [34, 46, 27, 20, 0]
];

array[R,R] of var 0..max(supply): flow;

% Disallow self-shipment
constraint forall(i in R)(flow[i,i] = 0);

% Ship out of each region cannot exceed supply
constraint forall(i in R)(
  sum(j in R)(flow[i,j]) <= supply[i]
);

% Each region must receive enough to meet its demand (with its own available cars)
constraint forall(j in R)(
  supply[j] + sum(i in R)(flow[i,j]) - sum(k in R)(flow[j,k]) >= demand[j]
);

var int: total_cost = sum(i in R, j in R)(cost[i,j] * flow[i,j]);

solve minimize total_cost;

output [
  "Minimum total cost (rounded to nearest dollar): ", show(total_cost), "\n",
  "Flow matrix (cars moved from i to j):\n"
] ++
[
  if j = 1 then "From region " ++ show(i) ++ ": " else "" endif ++
  show(flow[i,j]) ++ (if j = N then "\n" else " " endif)
  | i in R, j in R
];