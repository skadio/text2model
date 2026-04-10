int: K;
int: M;

set of int: ALLOYS = 1..K;
set of int: METALS = 1..M;

float: AlloyQuantity;
array[METALS] of float: Target;
array[ALLOYS] of float: Price;
array[ALLOYS, METALS] of float: Ratio;

array[ALLOYS] of var 0.0..AlloyQuantity: x;
var float: total_cost;

constraint sum(k in ALLOYS)(x[k]) = AlloyQuantity;

constraint forall(m in METALS) (
  sum(k in ALLOYS)(x[k] * Ratio[k, m]) = Target[m]
);

constraint total_cost = sum(k in ALLOYS)(x[k] * Price[k]);

solve minimize total_cost;