int: G = 3;
int: N = 4;

set of int: Grains = 1..G;
set of int: Nutrients = 1..N;

array[Grains, Nutrients] of int: nutr2 = array2d(Grains, Nutrients, [
  40, 20, 100, 12,
  60, 20,  60,  5,
 140,  0,   0, 20
]);

array[Nutrients] of int: req2 = [220, 36, 180, 28];
array[Grains] of int: cost = [41, 36, 96];

array[Grains] of var int: x;

constraint forall(g in Grains)(x[g] >= 0);

constraint forall(n in Nutrients)(
  sum(g in Grains)(nutr2[g,n] * x[g]) >= req2[n]
);

var int: total_cost = sum(g in Grains)(cost[g] * x[g]);

solve minimize total_cost;

output [
  "total_cost_cents = ", show(total_cost), "\n",
  "x = ", show(x), "\n"
];