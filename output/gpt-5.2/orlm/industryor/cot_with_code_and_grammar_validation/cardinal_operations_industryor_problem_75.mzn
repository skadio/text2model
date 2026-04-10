int: Q = 4;
set of int: QUARTERS = 1..Q;

int: capacity_m3 = 200000;
int: unit_m3 = 10000;
int: capUnits = capacity_m3 div unit_m3;

int: a = 70;
int: b = 100;

array[QUARTERS] of int: buyPrice  = [410, 430, 460, 450];
array[QUARTERS] of int: sellPrice = [425, 440, 465, 455];
array[QUARTERS] of int: maxSales  = [100, 140, 200, 160];

int: maxSalesUB = 200;
int: maxBuyUB   = capUnits + maxSalesUB;

array[QUARTERS] of var 0..maxBuyUB: buy;
array[QUARTERS] of var 0..maxSalesUB: sell;
array[0..Q] of var 0..capUnits: inv;

constraint inv[0] = 0;
constraint forall(q in QUARTERS) (
  inv[q] = inv[q-1] + buy[q] - sell[q]
);

constraint forall(q in QUARTERS) (sell[q] <= maxSales[q]);
constraint forall(q in QUARTERS) (inv[q] <= capUnits);

constraint inv[Q] = 0;

var int: profit =
    sum(q in QUARTERS) (sellPrice[q] * sell[q] - buyPrice[q] * buy[q])
  - (a + b) * sum(q in 1..Q-1) (inv[q]);

solve maximize profit;

output [
  "profit(10k yuan) = ", show(profit), "\n",
  "buy  (10k m3) = ", show(buy), "\n",
  "sell (10k m3) = ", show(sell), "\n",
  "inv  (10k m3) = ", show(inv), "\n"
];