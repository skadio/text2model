int: R = 4;
int: P = 2;

set of int: RAW = 1..R;
set of int: PROD = 1..P;

array[RAW] of int: avail = [20000, 15000, 15000, 10000];
array[RAW] of float: raw_cost = [17.0, 18.0, 20.5, 23.0];
array[RAW] of int: raw_oct = [86, 88, 92, 96];

array[PROD] of int: demand = [35000, 23000];
array[PROD] of float: price = [19.5, 22.0];
array[PROD] of int: min_oct = [89, 93];

int: U = max(demand);

array[RAW, PROD] of var 0..U: x;
array[PROD] of var 0..U: prod_vol;

var float: profit;

constraint forall(r in RAW) (
  sum(p in PROD)(x[r,p]) <= avail[r]
);

constraint forall(p in PROD) (
  prod_vol[p] = sum(r in RAW)(x[r,p])
);

constraint forall(p in PROD) (
  prod_vol[p] <= demand[p]
);

constraint forall(p in PROD) (
  sum(r in RAW)(int2float(raw_oct[r]) * int2float(x[r,p])) >= int2float(min_oct[p]) * int2float(prod_vol[p])
);

constraint profit =
  sum(p in PROD)(price[p] * int2float(prod_vol[p]))
  - sum(r in RAW, p in PROD)(raw_cost[r] * int2float(x[r,p]));

solve maximize profit;

output [
  "profit = ", show(profit), "\n",
  "prod_vol = ", show(prod_vol), "\n",
  "x = ", show(x), "\n"
];