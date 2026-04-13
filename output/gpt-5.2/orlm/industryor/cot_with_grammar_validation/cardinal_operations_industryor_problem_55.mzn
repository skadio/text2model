int: T = 3;
set of int: MONTHS = 1..T;

int: capacity = 5000;
int: init_inventory = 1000;
int: target_end_inventory = 2000;
float: init_cash = 20000.0;

array[MONTHS] of float: buy_price  = [2.85, 3.05, 2.90];
array[MONTHS] of float: sell_price = [3.10, 3.25, 2.95];

array[MONTHS] of var int: buy;
array[MONTHS] of var int: sell;
array[0..T] of var int: inv;

array[0..T] of var float: cash;

var float: profit;

constraint inv[0] = init_inventory;
constraint cash[0] = init_cash;

constraint forall(m in MONTHS) (
  inv[m] = inv[m-1] + buy[m] - sell[m]
);

constraint forall(m in MONTHS) (
  sell[m] <= inv[m-1]
);

constraint forall(m in MONTHS) (
  inv[m] <= capacity
);

constraint forall(m in MONTHS) (
  buy[m] >= 0 /\ sell[m] >= 0
);
constraint forall(m in 0..T) (
  inv[m] >= 0
);

constraint forall(m in MONTHS) (
  cash[m] = cash[m-1] - buy_price[m] * int2float(buy[m]) + sell_price[m] * int2float(sell[m])
);

constraint forall(m in MONTHS) (
  buy_price[m] * int2float(buy[m]) <= cash[m-1]
);

constraint inv[T] = target_end_inventory;

constraint profit = cash[T] - cash[0];

solve maximize profit;