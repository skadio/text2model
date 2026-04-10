int: N = 6;
set of int: CITIES = 1..N;

array[CITIES] of int: supply = [255, 250, 314, 8, 385, 440];
array[CITIES] of int: demand = [251, 200, 366, 114, 59, 287];

array[CITIES, CITIES] of int: cost = array2d(CITIES, CITIES, [
  0, 26, 39, 13, 37, 28,
  36, 0, 48, 5, 22, 14,
  38, 36, 0, 12, 45, 36,
  32, 18, 47, 0, 7, 9,
  18, 6, 12, 20, 0, 42,
  4, 28, 42, 43, 7, 0
]);

int: total_supply = sum(i in CITIES)(supply[i]);
int: total_demand = sum(i in CITIES)(demand[i]);
int: max_flow = max(total_supply, total_demand);

array[CITIES, CITIES] of var 0..max_flow: x;

constraint forall(i in CITIES)(x[i,i] = 0);

constraint forall(i in CITIES)(
  sum(j in CITIES)(x[i,j]) <= supply[i]
);

constraint forall(j in CITIES)(
  sum(i in CITIES)(x[i,j]) >= demand[j]
);

solve minimize sum(i in CITIES, j in CITIES)(cost[i,j] * x[i,j]);