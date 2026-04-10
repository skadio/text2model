% Purchasing and sales plan for 3 months (LP as an integer program)

int: T = 3;
set of int: Months = 1..T;

int: capacity = 500;
int: init_stock = 200;

array[Months] of int: buy_price  = [8, 6, 9];
array[Months] of int: sell_price = [9, 8, 10];

% Decision variables
array[Months] of var 0..capacity: buy;   % units purchased at beginning of month
array[Months] of var 0..capacity: sell;  % units sold during month
array[0..T]   of var 0..capacity: stock; % stock at end of month (stock[0]=initial)

constraint stock[0] = init_stock;

% Inventory balance and capacity
constraint forall(m in Months)(
  stock[m] = stock[m-1] + buy[m] - sell[m]
);

constraint forall(m in Months)(
  stock[m] <= capacity
);

% Cannot sell more than available inventory in that month
constraint forall(m in Months)(
  sell[m] <= stock[m-1] + buy[m]
);

% Objective: maximize total profit = revenue - cost
var int: profit = sum(m in Months)(sell_price[m] * sell[m] - buy_price[m] * buy[m]);

solve maximize profit;

output [
  "Profit = ", show(profit), "\n",
  "Month  Buy  Sell  EndStock\n"
] ++
[
  show(m) ++ "      " ++ show(buy[m]) ++ "    " ++ show(sell[m]) ++ "     " ++ show(stock[m]) ++ "\n"
  | m in Months
];