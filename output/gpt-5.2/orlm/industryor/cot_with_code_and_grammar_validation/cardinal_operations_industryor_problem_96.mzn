int: nRM = 4;
set of int: RM = 1..nRM;
int: nP = 2;
set of int: P = 1..nP;

array[RM] of int: sulfur_rm_ppm = [30, 10, 20, 10];
array[P] of int: sulfur_max_ppm = [25, 15];

array[RM] of float: cost_rm = [6.0, 16.0, 10.0, 15.0];
array[P] of float: price_p = [9.15, 9.15];

array[P] of float: demand_p = [100.0, 200.0];
float: D_supply_max = 50.0;

array[RM, P] of var float: x;
array[P] of var float: y;
var float: profit;

constraint forall(r in RM, p in P) (x[r,p] >= 0.0);
constraint forall(p in P) (y[p] >= 0.0);

constraint forall(p in P) (
  y[p] = sum(r in RM)(x[r,p])
);

constraint forall(p in P) (
  y[p] <= demand_p[p]
);

constraint forall(p in P) (
  sum(r in RM)(float(sulfur_rm_ppm[r]) * x[r,p]) <= float(sulfur_max_ppm[p]) * y[p]
);

constraint sum(p in P)(x[4,p]) <= D_supply_max;

constraint profit =
  sum(p in P)(price_p[p] * y[p]) - sum(r in RM, p in P)(cost_rm[r] * x[r,p]);

solve maximize profit;

output [
  "profit=", show(profit), "\n",
  "y=", show(y), "\n",
  "x=", show(x), "\n"
];