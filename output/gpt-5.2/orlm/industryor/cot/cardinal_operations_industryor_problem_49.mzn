% Parameters (with values embedded)
int: M = 6; % months July..December
set of int: Months = 1..M;

int: capacity = 500;
int: init_stock = 200;

array[Months] of int: buy_price  = [28, 24, 25, 27, 23, 23];
array[Months] of int: sell_price = [29, 24, 26, 28, 22, 25];

% Variables
array[Months] of var 0..capacity: buy_qty;
array[Months] of var 0..capacity: sell_qty;
array[0..M] of var 0..capacity: stock; % stock[t] = end-of-month inventory, stock[0]=end of June

% Constraints
constraint stock[0] = init_stock;

% Inventory balance: purchases at beginning of month, sales during month, stock at end
constraint forall(t in Months) (
  stock[t] = stock[t-1] + buy_qty[t] - sell_qty[t]
);

% Capacity limit at all times (after purchase and after sales)
constraint forall(t in Months) (
  stock[t-1] + buy_qty[t] <= capacity
);

% Cannot sell more than available after purchase
constraint forall(t in Months) (
  sell_qty[t] <= stock[t-1] + buy_qty[t]
);

% Objective
var int: profit = sum(t in Months)(sell_price[t]*sell_qty[t] - buy_price[t]*buy_qty[t]);
solve maximize profit;