int: R = 3;
int: P = 3;
set of int: RM = 1..R;
set of int: PR = 1..P;

int: S = 100;

array[RM] of int: rm_limit = [2000*S, 2500*S, 1200*S];

array[RM] of int: rm_cost_c = [200, 150, 100];
array[PR] of int: proc_fee_c = [50, 40, 30];
array[PR] of int: sell_price_c = [340, 285, 225];

array[RM, PR] of var 0..max(rm_limit): x;
array[PR] of var 0..sum(rm_limit): y;

constraint forall(j in PR) (
  y[j] = sum(i in RM)(x[i,j])
);

constraint forall(i in RM) (
  sum(j in PR)(x[i,j]) <= rm_limit[i]
);

constraint x[1,1] * 100 >= 60 * y[1];
constraint x[2,1] * 100 >= 15 * y[1];

constraint x[1,3] * 100 <= 20 * y[3];
constraint x[2,3] * 100 <= 60 * y[3];
constraint x[3,3] * 100 <= 50 * y[3];

var int: profit_c =
  sum(j in PR)(sell_price_c[j] * y[j])
  - sum(i in RM, j in PR)(rm_cost_c[i] * x[i,j])
  - sum(j in PR)(proc_fee_c[j] * y[j]);

solve maximize profit_c;

output [
  "Produced (kg):\n",
  "A = ", show(y[1] div S), ".", show((y[1] mod S) div 10), show((y[1] mod S) mod 10), "\n",
  "B = ", show(y[2] div S), ".", show((y[2] mod S) div 10), show((y[2] mod S) mod 10), "\n",
  "C = ", show(y[3] div S), ".", show((y[3] mod S) div 10), show((y[3] mod S) mod 10), "\n",
  "Profit (Yuan) = ", show(profit_c div 100), ".", show((profit_c mod 100) div 10), show((profit_c mod 100) mod 10), "\n"
];