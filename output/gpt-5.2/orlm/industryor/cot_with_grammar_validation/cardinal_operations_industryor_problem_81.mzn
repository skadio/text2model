int: N = 5;
set of int: TYPES = 1..N;

int: total_area = 5000;
float: rent_rate = 0.20;

array[TYPES] of int: area_per_shop = [250, 350, 800, 400, 500];
array[TYPES] of int: min_shops     = [1,   1,   1,   0,   1];
array[TYPES] of int: max_shops     = [3,   2,   3,   2,   3];

array[TYPES, 0..3] of int: profit_per_shop =
[| 0,  9,  8,  7
 | 0, 10,  9,  0
 | 0, 27, 21, 20
 | 0, 16, 10,  0
 | 0, 17, 15, 12
 |];

array[TYPES] of var 0..3: x;

var 0..total_area: used_area;

int: max_total_profit =
  sum(t in TYPES)(max_shops[t] * max([profit_per_shop[t,k] | k in 1..3]));

var 0..max_total_profit: total_profit;
var 0.0..(rent_rate * int2float(max_total_profit)): rent_income;

constraint forall(t in TYPES) (
  x[t] >= min_shops[t] /\ x[t] <= max_shops[t]
);

constraint used_area = sum(t in TYPES)(area_per_shop[t] * x[t]);
constraint used_area <= total_area;

constraint total_profit =
  sum(t in TYPES)(x[t] * profit_per_shop[t, x[t]]);

constraint rent_income = rent_rate * int2float(total_profit);

solve maximize rent_income;