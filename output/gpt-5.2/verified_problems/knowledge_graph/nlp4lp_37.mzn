int: K;
int: M;

set of int: FOODS = 1..K;
set of int: NUTRIENTS = 1..M;

array[FOODS] of float: Price;
array[NUTRIENTS] of float: Demand;
array[FOODS, NUTRIENTS] of float: Nutrition;

array[FOODS] of var float: x; % amount of each food to buy (>= 0)

constraint forall(k in FOODS) (x[k] >= 0.0);

constraint
  forall(m in NUTRIENTS) (
    sum(k in FOODS) (Nutrition[k,m] * x[k]) >= Demand[m]
  );

var float: total_cost = sum(k in FOODS) (Price[k] * x[k]);

solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "x = ", show(x), "\n"
];