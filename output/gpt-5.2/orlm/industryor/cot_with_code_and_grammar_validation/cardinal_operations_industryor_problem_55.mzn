int: T = 3;
set of int: M = 1..T;

int: capacity = 5000;
int: init_stock = 1000;
int: target_end_stock = 2000;

int: init_cash_yuan = 20000;
int: init_cash_c = init_cash_yuan * 100;

array[M] of int: buy_c  = [285, 305, 290];
array[M] of int: sell_c = [310, 325, 295];

int: max_cash_c = init_cash_c + T * capacity * max(sell_c);

array[M] of var 0..capacity: buy;
array[M] of var 0..capacity: sell;
array[0..T] of var 0..capacity: stock;
array[0..T] of var 0..max_cash_c: cash_c;

var -max_cash_c..max_cash_c: profit_c;

constraint stock[0] = init_stock;
constraint cash_c[0] = init_cash_c;

constraint sell[1] = 0;

constraint forall(m in M) (
  stock[m] = stock[m-1] + buy[m] - sell[m]
);

constraint forall(m in 2..T) (
  sell[m] <= stock[m-1]
);

constraint forall(m in 0..T) (
  stock[m] <= capacity
);

constraint forall(m in M) (
  cash_c[m] = cash_c[m-1] - buy_c[m] * buy[m] + sell_c[m] * sell[m]
);

constraint forall(m in M) (
  buy_c[m] * buy[m] <= cash_c[m-1]
);

constraint stock[T] = target_end_stock;

constraint profit_c = cash_c[T] - cash_c[0];

solve maximize profit_c;

output
  [
    "Profit (yuan): ", show(profit_c div 100), ".", show((profit_c mod 100 + 100) mod 100), "\n",
    "Month  Buy  Sell  StockEnd  CashEnd(yuan)\n"
  ]
  ++
  [
    show(m) ++ "      " ++ show(buy[m]) ++ "   " ++ show(sell[m]) ++ "     " ++ show(stock[m]) ++
    "      " ++ show(cash_c[m] div 100) ++ "." ++ show((cash_c[m] mod 100 + 100) mod 100) ++ "\n"
    | m in M
  ];