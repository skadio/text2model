int: T = 6;
set of int: M = 1..T;

int: capacity = 500;
int: init_stock = 200;

array[M] of int: buy_price  = [28, 24, 25, 27, 23, 23];
array[M] of int: sell_price = [29, 24, 26, 28, 22, 25];

array[M] of var 0..capacity: buy_qty;
array[M] of var 0..capacity: sell_qty;
array[0..T] of var 0..capacity: stock;

constraint stock[0] = init_stock;

constraint forall(m in M) (
  stock[m] = stock[m-1] + buy_qty[m] - sell_qty[m]
);

constraint forall(m in M) (
  sell_qty[m] <= stock[m-1] + buy_qty[m]
);

constraint forall(m in M) (
  stock[m] <= capacity
);

var int: profit;
constraint profit = sum(m in M)(sell_price[m] * sell_qty[m] - buy_price[m] * buy_qty[m]);

solve maximize profit;

output [
  "profit=", show(profit), "\n",
  "buy_qty=", show(buy_qty), "\n",
  "sell_qty=", show(sell_qty), "\n",
  "stock=", show(stock), "\n"
];