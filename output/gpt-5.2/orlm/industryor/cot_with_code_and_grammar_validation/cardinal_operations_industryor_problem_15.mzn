int: T = 3;
set of int: Months = 1..T;

int: capacity = 500;
int: init_stock = 200;

array[Months] of int: buy_price = [8, 6, 9];
array[Months] of int: sell_price = [9, 8, 10];

array[Months] of var 0..capacity: buy;
array[Months] of var 0..capacity: sell;
array[0..T] of var 0..capacity: stock;

constraint stock[0] = init_stock;

constraint forall(m in Months) (
  stock[m] = stock[m-1] + buy[m] - sell[m]
);

constraint forall(m in Months) (
  sell[m] <= stock[m-1] + buy[m]
);

solve maximize sum(m in Months) (
  sell_price[m] * sell[m] - buy_price[m] * buy[m]
);

output [
  "buy  = ", show(buy), "\n",
  "sell = ", show(sell), "\n",
  "stock= ", show(stock), "\n",
  "profit = ", show(sum(m in Months)(sell_price[m] * sell[m] - buy_price[m] * buy[m])), "\n"
];