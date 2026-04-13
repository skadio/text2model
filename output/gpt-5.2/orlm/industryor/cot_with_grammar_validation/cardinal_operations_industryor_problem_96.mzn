int: nRM = 4;
set of int: RM = 1..nRM;

int: nP = 2;
set of int: P = 1..nP;

array[RM] of float: sulfur = [0.03, 0.01, 0.02, 0.01];
array[RM] of float: buyCost = [6.0, 16.0, 10.0, 15.0];

array[P] of float: maxSulfur = [0.025, 0.015];
array[P] of float: sellPrice = [9.15, 9.15];
array[P] of float: demand = [100.0, 200.0];

float: D_max = 50.0;

array[P, RM] of var 0.0..1000.0: x;
array[P] of var 0.0..1000.0: y;

constraint forall(p in P, r in RM) (x[p, r] >= 0.0);
constraint forall(p in P) (y[p] >= 0.0);

constraint forall(p in P) (
  y[p] = sum(r in RM)(x[p, r])
);

constraint forall(p in P) (
  y[p] <= demand[p]
);

constraint forall(p in P) (
  sum(r in RM)(sulfur[r] * x[p, r]) <= maxSulfur[p] * y[p]
);

constraint sum(p in P)(x[p, 4]) <= D_max;

constraint x[1, 1] * x[2, 2] = x[2, 1] * x[1, 2];
constraint x[1, 1] * x[2, 4] = x[2, 1] * x[1, 4];
constraint x[1, 2] * x[2, 4] = x[2, 2] * x[1, 4];

var float: profit =
  sum(p in P)(sellPrice[p] * y[p]) - sum(p in P, r in RM)(buyCost[r] * x[p, r]);

solve maximize profit;

output [
  "profit=", show(profit), "\n",
  "y=", show(y), "\n",
  "x=", show(x), "\n"
];