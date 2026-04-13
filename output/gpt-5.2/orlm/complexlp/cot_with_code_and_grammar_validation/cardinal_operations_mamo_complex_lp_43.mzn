% Parameters
int: N = 4;
set of int: W = 1..N;

array[W] of int: supply = [500, 497, 354, 223];
array[W] of int: demand = [17, 65, 26, 332];

array[W,W] of int: cost =
[| 0, 17,  3,  5
 | 39, 0, 18, 50
 |  8, 45, 0, 15
 | 11,  4, 29, 0 |];

int: total_supply = sum(w in W)(supply[w]);
int: total_demand = sum(w in W)(demand[w]);
int: U = total_supply; % safe upper bound on any shipment

% Variables
array[W,W] of var 0..U: x; % x[i,j] = tons moved from i to j

% Constraints
constraint
  total_supply = total_demand;

constraint
  forall(i in W)(x[i,i] = 0);

constraint
  forall(i in W)(
    sum(j in W)(x[i,j]) <= supply[i]
  );

constraint
  forall(j in W)(
    sum(i in W)(x[i,j]) = demand[j]
  );

% Objective
solve minimize sum(i in W, j in W)(cost[i,j] * x[i,j]);

output [show(sum(i in W, j in W)(cost[i,j] * x[i,j]))];