% Parameters (with values embedded)
int: N = 5;
set of int: R = 1..N;

array[R] of int: supply = [133, 189, 446, 346, 184];
array[R] of int: demand = [146, 270, 313, 102, 412];

% cost[i,j] = cost to ship 1 unit from region i to region j
array[R,R] of int: cost =
[|  0, 24, 32, 44, 46
 | 41,  0,  6, 11, 49
 | 40, 10,  0, 40, 45
 | 22, 22, 34,  0,  1
 | 46, 14, 35, 36,  0 |];

int: total_supply = sum(r in R)(supply[r]);
int: total_demand = sum(r in R)(demand[r]);
int: U = total_supply; % valid upper bound on any single shipment

% Variables
array[R,R] of var 0..U: x; % x[i,j] units shipped from i to j (including i=j allowed but cost=0)

% Constraints
constraint total_supply >= total_demand;

% Do not ship from a region to itself (can also be omitted since cost is 0, but keeps model clean)
constraint forall(r in R)(x[r,r] = 0);

% Flow conservation: outgoing minus incoming equals surplus (supply - demand)
constraint forall(r in R)(
  sum(j in R)(x[r,j]) - sum(i in R)(x[i,r]) = supply[r] - demand[r]
);

% Objective
solve minimize sum(i in R, j in R)(cost[i,j] * x[i,j]);