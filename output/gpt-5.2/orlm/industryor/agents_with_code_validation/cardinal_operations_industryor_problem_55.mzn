% Grain trading planning (3 months)
% Maximize profit with inventory and cash constraints, with 1-month selling delay.

int: T = 3;
set of int: MONTHS = 1..T;

int: warehouse_capacity = 5000;
int: initial_inventory = 1000;
int: final_inventory_target = 2000;
int: initial_cash_yuan = 20000;

array[MONTHS] of float: buy_price  = [2.85, 3.05, 2.90];
array[MONTHS] of float: sell_price = [3.10, 3.25, 2.95];

% Decision variables (integer dan)
array[MONTHS] of var 0..warehouse_capacity: buy_qty;
array[MONTHS] of var 0..warehouse_capacity: sell_qty;

% State variables
array[0..T] of var 0..warehouse_capacity: inventory;
array[0..T] of var float: cash;

var float: profit;

% Initial conditions
constraint inventory[0] = initial_inventory;
constraint cash[0] = initial_cash_yuan;   % int is implicitly convertible to float

% Inventory balance
constraint forall(t in MONTHS) (
  inventory[t] = inventory[t-1] + buy_qty[t] - sell_qty[t]
);

% Selling delay: can only sell what was in stock at start of month t (end of month t-1)
constraint forall(t in MONTHS) (
  sell_qty[t] <= inventory[t-1]
);

% Cash balance (pay purchases and receive sales in same month)
constraint forall(t in MONTHS) (
  cash[t] = cash[t-1]
            - buy_price[t] * buy_qty[t]
            + sell_price[t] * sell_qty[t]
);

% No borrowing
constraint forall(t in 0..T) (cash[t] >= 0.0);

% Final inventory requirement
constraint inventory[T] = final_inventory_target;

% Profit definition
constraint profit = cash[T] - cash[0];

solve maximize profit;