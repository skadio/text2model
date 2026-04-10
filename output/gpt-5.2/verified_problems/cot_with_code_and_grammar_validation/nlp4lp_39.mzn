int: K;
int: M;

float: AlloyQuantity;
array[1..M] of float: Target;

array[1..K, 1..M] of float: Ratio;
array[1..K] of float: Price;

array[1..K] of var float: x;
var float: total_cost;

constraint forall(k in 1..K) (x[k] >= 0.0);

constraint abs(sum(m in 1..M)(Target[m]) - AlloyQuantity) <= 1.0e-6;

constraint sum(k in 1..K)(x[k]) = AlloyQuantity;

constraint forall(m in 1..M) (
  sum(k in 1..K)(x[k] * Ratio[k, m]) = Target[m]
);

constraint total_cost = sum(k in 1..K)(x[k] * Price[k]);

solve minimize total_cost;