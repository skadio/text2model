int: N = 6;
set of int: CITIES = 1..N;

array[CITIES] of int: supply = [255, 250, 314, 8, 385, 440];
array[CITIES] of int: demand = [251, 200, 366, 114, 59, 287];

array[CITIES, CITIES] of int: cost = array2d(CITIES, CITIES,
[
  0, 26, 39, 13, 37, 28,
  36, 0, 48, 5, 22, 14,
  38, 36, 0, 12, 45, 36,
  32, 18, 47, 0, 7, 9,
  18, 6, 12, 20, 0, 42,
  4, 28, 42, 43, 7, 0
]);

int: total_supply = sum(i in CITIES)(supply[i]);
int: max_ship = total_supply;

array[CITIES, CITIES] of var 0..max_ship: x;

constraint forall(i in CITIES)(x[i,i] = 0);

constraint forall(i in CITIES)(
  sum(j in CITIES)(x[i,j]) <= supply[i]
);

constraint forall(j in CITIES)(
  supply[j] + sum(i in CITIES)(x[i,j]) - sum(k in CITIES)(x[j,k]) >= demand[j]
);

var 0..(max_ship * 1000): total_cost;
constraint total_cost = sum(i in CITIES, j in CITIES)(cost[i,j] * x[i,j]);

solve minimize total_cost;

output
  ["Minimum cost = ", show(total_cost), "\n",
   "Shipments (from i to j):\n"]
  ++
  [ concat([ "x[", show(i), ",", show(j), "]=", show(x[i,j]),
             if j = N then "\n" else "  " endif
           | j in CITIES ])
    | i in CITIES
  ];