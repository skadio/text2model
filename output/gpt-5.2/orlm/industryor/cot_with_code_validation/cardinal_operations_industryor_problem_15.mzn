% Purchasing and sales plan for 3 months (linear model)
% Data (embedded)
int: T = 3;
set of int: M = 1..T;

int: capacity = 500;
int: init_stock = 200;

array[M] of int: buy_price  = [8, 6, 9];
array[M] of int: sell_price = [9, 8, 10];

% Decision variables
array[M] of var 0..capacity: buy;
array[M] of var 0..capacity: sell;
array[0..T] of var 0..capacity: stock;

% Inventory balance
constraint stock[0] = init_stock;
constraint forall(t in M)(
  stock[t] = stock[t-1] + buy[t] - sell[t]
);

% Cannot sell more than available stock after purchasing that month
constraint forall(t in M)(
  sell[t] <= stock[t-1] + buy[t]
);

% Objective: maximize total profit
var int: profit = sum(t in M)(sell_price[t] * sell[t] - buy_price[t] * buy[t]);

solve maximize profit;

output [
  "profit=", show(profit), "\n",
  "buy=", show(buy), "\n",
  "sell=", show(sell), "\n",
  "stock=", show([stock[t] | t in 0..T]), "\n"
];