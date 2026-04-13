int: K;
int: M;

array[1..K] of float: Price;
array[1..M] of float: Demand;
array[1..K, 1..M] of float: Nutrition;

array[1..K] of var float: Buy;

var float: TotalCost = sum(k in 1..K)(Price[k] * Buy[k]);

constraint forall(k in 1..K)(Buy[k] >= 0.0);

constraint forall(m in 1..M)(
  sum(k in 1..K)(Nutrition[k, m] * Buy[k]) >= Demand[m]
);

solve minimize TotalCost;

output [
  "TotalCost=", show(TotalCost), "\n",
  "Buy=[", concat([ if k > 1 then ", " else "" endif ++ show(Buy[k]) | k in 1..K ]), "]\n"
];