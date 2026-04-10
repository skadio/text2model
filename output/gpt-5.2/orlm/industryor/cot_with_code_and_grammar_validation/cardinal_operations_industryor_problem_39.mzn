int: n = 4;
set of int: P = 1..n;

int: STEEL = 1;
int: ENGINES = 2;
int: ELECTRONICS = 3;
int: PLASTIC = 4;

array[P] of int: price = [500, 1500, 300, 1200];

array[P] of int: imp_goods = [250, 300, 50, 300];

array[P] of int: labor_pm = [6, 12, 6, 24];

int: labor_total = 830000;

int: ub_engines = 650000;
int: ub_plastic = 60000;

int: SCALE = 100;

array[P, P] of int: a = array2d(P, P, [
  0,  2,  0,  1,
  80, 0,  15, 11,
  1,  1,  0,  5,
  20, 3,  5,  0
]);

int: X_UB = 2000000;
array[P] of var 0..X_UB: x;

constraint x[ENGINES] <= ub_engines;
constraint x[PLASTIC] <= ub_plastic;

constraint sum(i in P)(labor_pm[i] * x[i]) <= labor_total;

constraint forall(j in P)(
  SCALE * x[j] >= sum(i in P)(a[i, j] * x[i])
);

var int: obj =
  sum(j in P)(
    price[j] * (SCALE * x[j] - sum(i in P)(a[i, j] * x[i]))
  )
  - SCALE * sum(i in P)(imp_goods[i] * x[i]);

solve maximize obj;

output [
  "steel=", show(x[STEEL]), "\n",
  "engines=", show(x[ENGINES]), "\n",
  "electronics=", show(x[ELECTRONICS]), "\n",
  "plastic=", show(x[PLASTIC]), "\n",
  "obj=", show(obj), "\n"
];