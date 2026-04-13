int: R = 3;
int: P = 3;

set of int: RM = 1..R;
set of int: PR = 1..P;

array[RM, PR] of float: lb = array2d(RM, PR, [
  0.60, 0.00, 0.00,
  0.15, 0.00, 0.00,
  0.00, 0.00, 0.00
]);

array[RM, PR] of float: ub = array2d(RM, PR, [
  1.00, 1.00, 0.20,
  1.00, 1.00, 0.60,
  1.00, 1.00, 0.50
]);

array[RM] of float: raw_cost = [2.00, 1.50, 1.00];
array[RM] of float: raw_limit = [2000.0, 2500.0, 1200.0];

array[PR] of float: proc_fee = [0.50, 0.40, 0.30];
array[PR] of float: sell_price = [3.40, 2.85, 2.25];

array[PR] of var float: y;
array[RM, PR] of var float: x;
array[RM, PR] of var float: w;

constraint forall(p in PR) (
  sum(r in RM)(x[r,p]) = 1.0
);

constraint forall(r in RM, p in PR) (
  x[r,p] >= lb[r,p] /\ x[r,p] <= ub[r,p]
);

constraint forall(r in RM, p in PR) (
  w[r,p] = x[r,p] * y[p]
);

constraint forall(r in RM) (
  sum(p in PR)(w[r,p]) <= raw_limit[r]
);

var float: profit =
  sum(p in PR)((sell_price[p] - proc_fee[p]) * y[p])
  - sum(r in RM, p in PR)(raw_cost[r] * w[r,p]);

solve maximize profit;

output [
  "profit=", show(profit), "\n",
  "y=", show(y), "\n",
  "x=\n", show(x), "\n",
  "w=\n", show(w), "\n"
];