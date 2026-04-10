% Parameters (with values embedded)
int: T = 3;                         % months 1..3
set of int: Months = 1..T;

int: capacity = 500;                % warehouse capacity (units)
int: initial_stock = 200;           % stock at end of previous year (units)

array[Months] of int: buy_price  = [8, 6, 9];   % Yuan/unit
array[Months] of int: sell_price = [9, 8, 10];  % Yuan/unit

% Variables
array[Months] of var 0..capacity: buy;          % units purchased at beginning of month
array[Months] of var 0..capacity: sell;         % units sold during month
array[0..T] of var 0..capacity: stock;          % end-of-month inventory, stock[0]=initial

% Constraints
constraint stock[0] = initial_stock;

% Inventory balance: stock[t] = stock[t-1] + buy[t] - sell[t]
constraint forall(t in Months) (
  stock[t] = stock[t-1] + buy[t] - sell[t]
);

% Cannot sell more than available in the month
constraint forall(t in Months) (
  sell[t] <= stock[t-1] + buy[t]
);

% Warehouse capacity each month (already bounded, but stated explicitly)
constraint forall(t in 0..T) (
  stock[t] <= capacity
);

% Objective
var int: profit = sum(t in Months)(sell_price[t] * sell[t] - buy_price[t] * buy[t]);
solve maximize profit;