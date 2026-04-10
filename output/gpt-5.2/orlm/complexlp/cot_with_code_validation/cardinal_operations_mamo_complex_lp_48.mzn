% Medical supplies redistribution (min-cost flow / transportation)

int: N = 7;
set of int: F = 1..N;

array[F] of int: supply = [229, 345, 231, 164, 354, 437, 265];
array[F] of int: demand = [158, 14, 326, 432, 207, 215, 233];

array[F, F] of int: cost = array2d(F, F, [
  0, 26,  8,  7, 34, 35, 34,
 41,  0, 27, 31,  3, 33, 36,
 20, 49,  0, 48, 21, 38, 42,
 10, 35, 26,  0, 21, 33, 31,
 21, 30, 24, 25,  0,  5,  8,
 27, 34, 34, 26, 27,  0, 43,
 38, 20, 11, 43, 49,  9,  0
]);

int: total_supply = sum(i in F)(supply[i]);
int: total_demand = sum(i in F)(demand[i]);

% Total supply must equal total demand for exact fulfillment
constraint total_supply = total_demand;

int: UB = total_supply;

% Decision variables: shipped units from i to j
array[F, F] of var 0..UB: x;

% Supply constraints (outgoing from i cannot exceed supply at i)
constraint forall(i in F)(
  sum(j in F)(x[i, j]) <= supply[i]
);

% Demand constraints (incoming to j must equal demand at j)
constraint forall(j in F)(
  sum(i in F)(x[i, j]) = demand[j]
);

% No self-shipment
constraint forall(i in F)(x[i, i] = 0);

% Objective: minimize total transport cost
var int: total_cost = sum(i in F, j in F)(cost[i, j] * x[i, j]);

solve minimize total_cost;

output ["minimum_cost=" ++ show(total_cost) ++ "\n"];