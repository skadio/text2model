% Parameters (with values embedded)
int: R = 5;
set of int: REGIONS = 1..R;

array[REGIONS] of int: available = [115, 385, 410, 480, 610];
array[REGIONS] of int: needed    = [200, 500, 800, 200, 300];

% Cost matrix (cost[i,j] = cost to move 1 car from i to j). Diagonal is 0 (no move).
array[REGIONS, REGIONS] of int: cost =
[|  0, 10, 12, 17, 34
 | 10,  0, 18,  8, 46
 | 12, 18,  0,  9, 27
 | 17,  8,  9,  0, 20
 | 34, 46, 27, 20,  0 |];

% Variables
% x[i,j] = number of cars moved from region i to region j
array[REGIONS, REGIONS] of var 0..sum(available): x;

var int: total_cost = sum(i,j in REGIONS)(cost[i,j] * x[i,j]);

% Constraints
% No self-shipment
constraint forall(i in REGIONS)(x[i,i] = 0);

% Flow balance: available + inflow - outflow = needed
constraint forall(r in REGIONS)(
  available[r]
  + sum(i in REGIONS where i != r)(x[i,r])
  - sum(j in REGIONS where j != r)(x[r,j])
  = needed[r]
);

% Objective
solve minimize total_cost;