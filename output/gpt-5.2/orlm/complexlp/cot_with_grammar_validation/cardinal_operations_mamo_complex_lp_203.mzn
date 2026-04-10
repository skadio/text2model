int: R = 4;
int: P = 2;

set of int: RAW = 1..R;
set of int: PROD = 1..P;

array[RAW] of float: raw_oct = [86.0, 88.0, 92.0, 96.0];
array[RAW] of float: raw_cost = [17.0, 18.0, 20.5, 23.0];
array[RAW] of float: raw_avail = [20000.0, 15000.0, 15000.0, 10000.0];

array[PROD] of float: prod_min_oct = [89.0, 93.0];
array[PROD] of float: prod_price = [19.5, 22.0];
array[PROD] of float: prod_demand = [35000.0, 23000.0];

array[RAW, PROD] of var float: x;
array[PROD] of var float: y;
var float: profit;

constraint forall(p in PROD) (
  y[p] = sum(r in RAW)(x[r,p])
);

constraint forall(r in RAW) (
  sum(p in PROD)(x[r,p]) <= raw_avail[r]
);

constraint forall(p in PROD) (
  y[p] <= prod_demand[p]
);

constraint forall(p in PROD) (
  sum(r in RAW)(raw_oct[r] * x[r,p]) >= prod_min_oct[p] * y[p]
);

constraint profit =
  sum(p in PROD)(prod_price[p] * y[p])
  - sum(r in RAW, p in PROD)(raw_cost[r] * x[r,p]);

solve maximize profit;

output [
  "profit = ", show(profit), "\n",
  "y = ", show(y), "\n",
  "x = ", show(x), "\n"
];