int: Q = 4;
set of int: QUARTERS = 1..Q;

int: CAP = 200000;
int: a = 70;
int: b = 100;

array[QUARTERS] of int: buyPrice  = [410, 430, 460, 450];
array[QUARTERS] of int: sellPrice = [425, 440, 465, 455];
array[QUARTERS] of int: maxSales  = [100, 140, 200, 160];

array[QUARTERS] of var 0..CAP: buy;
array[QUARTERS] of var 0..CAP: sell;
array[0..Q] of var 0..CAP: inv;

var int: profit;

constraint inv[0] = 0;

constraint forall(t in QUARTERS) (
  inv[t] = inv[t-1] + buy[t] - sell[t]
);

constraint forall(t in QUARTERS) (
  sell[t] <= maxSales[t]
);

constraint forall(t in 0..Q) (
  inv[t] <= CAP
);

constraint inv[Q] = 0;

constraint profit =
    sum(t in QUARTERS) (sellPrice[t] * sell[t])
  - sum(t in QUARTERS) (buyPrice[t] * buy[t])
  - sum(t in 1..Q-1) ((a + b) * inv[t]);

solve maximize profit;

output [
  "profit=", show(profit), "\n",
  "buy=", show(buy), "\n",
  "sell=", show(sell), "\n",
  "inv=", show(inv), "\n"
];