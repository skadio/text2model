% Parameters
int: N = 4;
set of int: H = 1..N;

array[H] of int: supply = [480, 492, 74, 317];
array[H] of int: demand = [61, 313, 93, 199];

array[H, H] of int: cost =
[|  0,  8, 42, 27
 | 17,  0, 13, 30
 |  4, 14,  0, 16
 | 33,  9, 42,  0 |];

int: total_supply = sum(i in H)(supply[i]);
int: total_demand = sum(i in H)(demand[i]);

% Variables
int: U = total_supply; % safe upper bound on any single transfer
array[H, H] of var 0..U: x; % x[i,j] units shipped from i to j (i may equal j, forced to 0)

var 0..(U * sum(i in H, j in H)(cost[i,j])): total_cost;

% Constraints
constraint total_supply >= total_demand;

constraint forall(i in H)(x[i,i] = 0);

% Flow balance: final_i = supply_i - out_i + in_i, and must cover demand_i
constraint
  forall(i in H)(
    supply[i] - sum(j in H)(x[i,j]) + sum(j in H)(x[j,i]) >= demand[i]
  );

constraint total_cost = sum(i in H, j in H)(cost[i,j] * x[i,j]);

% Objective
solve minimize total_cost;