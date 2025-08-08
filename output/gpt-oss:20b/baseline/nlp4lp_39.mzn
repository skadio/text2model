int: K;
int: M;
int: AlloyQuantity;
array[1..M] of float: Target;
array[1..K, 1..M] of float: Ratio;
array[1..K] of float: Price;

var float: totalCost = sum(k in 1..K)(x[k] * Price[k]);

var float: x[1..K] >= 0.0;

constraint sum(k in 1..K)(x[k]) == AlloyQuantity;
constraint forall(m in 1..M)(sum(k in 1..K)(x[k] * Ratio[k,m]) == Target[m]);

solve minimize totalCost;

output [
  "x: ", show(x), "\n",
  "TotalCost: ", show(totalCost), "\n"
];