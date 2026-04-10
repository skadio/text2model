int: N = 4;
set of int: CLINICS = 1..N;

array[CLINICS] of int: stock = [330, 294, 474, 86];
array[CLINICS] of int: need  = [476,  92, 385, 203];

array[CLINICS, CLINICS] of int: cost =
[|  0,  2, 12, 19
 | 28,  0,  9, 10
 | 23, 46,  0,  7
 | 19, 16, 23,  0
 |];

int: total_stock = sum(i in CLINICS)(stock[i]);
int: total_need  = sum(i in CLINICS)(need[i]);

array[CLINICS, CLINICS] of var 0..total_stock: x;

constraint forall(i in CLINICS)(x[i,i] = 0);

constraint forall(i in CLINICS)(
  sum(j in CLINICS)(x[i,j]) <= stock[i]
);

constraint forall(j in CLINICS)(
  stock[j] - sum(k in CLINICS)(x[j,k]) + sum(i in CLINICS)(x[i,j]) >= need[j]
);

constraint total_stock >= total_need;

solve minimize sum(i in CLINICS, j in CLINICS)(cost[i,j] * x[i,j]);

output [
  "min_cost=", show(sum(i in CLINICS, j in CLINICS)(cost[i,j] * x[i,j])), "\n",
  "x=\n",
  show(x), "\n"
];