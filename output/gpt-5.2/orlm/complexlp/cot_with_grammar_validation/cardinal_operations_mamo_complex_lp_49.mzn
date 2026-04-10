int: N = 7;
set of int: CENTERS = 1..N;

array[CENTERS] of int: supply = [97, 458, 473, 380, 34, 399, 163];
array[CENTERS] of int: demand = [119, 275, 36, 459, 17, 128, 425];

array[CENTERS, CENTERS] of int: cost = array2d(CENTERS, CENTERS, [
  0, 41, 42, 31, 39,  2, 18,
 48,  0,  9, 22, 47, 29, 39,
 36, 22,  0, 29, 45, 33, 45,
 19,  5, 10,  0,  3, 42, 20,
 13, 10, 21,  7,  0, 35, 11,
  5, 35, 29, 16, 40,  0,  9,
  7, 24, 26, 38, 33, 13,  0
]);

int: total_supply = sum(i in CENTERS)(supply[i]);
int: total_demand = sum(i in CENTERS)(demand[i]);

array[CENTERS, CENTERS] of var 0..total_supply: x;
var 0..(sum(i in CENTERS, j in CENTERS)(cost[i,j]) * total_supply): total_cost;

constraint forall(i in CENTERS)(x[i,i] = 0);

constraint total_supply = total_demand;

constraint forall(i in CENTERS)(
  sum(j in CENTERS)(x[i,j]) <= supply[i]
);

constraint forall(j in CENTERS)(
  supply[j] + sum(i in CENTERS)(x[i,j]) - sum(k in CENTERS)(x[j,k]) = demand[j]
);

constraint total_cost = sum(i in CENTERS, j in CENTERS)(cost[i,j] * x[i,j]);

solve minimize total_cost;

output ["total_cost = \(total_cost)\n"];