int: K;
int: M;

array[1..K] of int: Price;
array[1..M] of int: Demand;
array[1..K, 1..M] of int: Nutrition;

var int: quantity[1..K] >= 0;
var int: total_cost;

constraint
  forall(m in 1..M) (
    sum(k in 1..K) quantity[k] * Nutrition[k, m] >= Demand[m]
  );

constraint
  total_cost = sum(k in 1..K) quantity[k] * Price[k];

solve minimize total_cost;

output [
  "Quantity: ", show(quantity), "\n",
  "Total cost: ", show(total_cost), "\n"
];