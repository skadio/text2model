% Parameters
int: N = 4;
set of int: H = 1..N;

array[H] of int: supply = [480, 492, 74, 317];
array[H] of int: demand = [61, 313, 93, 199];

array[H, H] of int: cost = array2d(H, H, [
  0,  8, 42, 27,
 17,  0, 13, 30,
  4, 14,  0, 16,
 33,  9, 42,  0
]);

% Decision variables: amount shipped from i to j
array[H, H] of var 0..max(supply): x;

% Total cost (safe upper bound)
var 0..(max(supply) * max([cost[i,j] | i in H, j in H]) * N * N): total_cost;

% Constraints
constraint forall(i in H) (x[i,i] = 0);

% Cannot ship more than available at each hospital
constraint forall(i in H) (
  (sum(j in H) (x[i,j])) <= supply[i]
);

% Final stock at each hospital must meet its demand:
% final_j = supply[j] + inflow_j - outflow_j
constraint forall(j in H) (
  supply[j] + (sum(i in H) (x[i,j])) - (sum(k in H) (x[j,k])) >= demand[j]
);

% Objective
constraint total_cost = sum(i in H, j in H) (cost[i,j] * x[i,j]);

solve minimize total_cost;