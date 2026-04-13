% Purchase/Sales planning (July..December)

% Parameters
int: T = 6;
set of int: MONTHS = 1..T;

array[MONTHS] of int: buyPrice  = [28, 24, 25, 27, 23, 23];
array[MONTHS] of int: sellPrice = [29, 24, 26, 28, 22, 25];

int: capacity = 500;
int: initialStock = 200;

% Variables
array[MONTHS] of var 0..capacity: buyQty;
array[MONTHS] of var 0..capacity: sellQty;
array[0..T] of var 0..capacity: stock;

% Constraints
constraint stock[0] = initialStock;

constraint forall(m in MONTHS) (
  stock[m] = stock[m-1] + buyQty[m] - sellQty[m]
);

% Cannot sell more than available after buying at beginning of month
constraint forall(m in MONTHS) (
  sellQty[m] <= stock[m-1] + buyQty[m]
);

% Warehouse capacity
constraint forall(m in 0..T) (
  stock[m] <= capacity
);

% Objective: maximize total profit (revenue - purchase cost)
var int: profit = sum(m in MONTHS) (sellPrice[m] * sellQty[m] - buyPrice[m] * buyQty[m]);

solve maximize profit;

output [
  "profit = ", show(profit), "\n",
  "buyQty  = ", show(buyQty), "\n",
  "sellQty = ", show(sellQty), "\n",
  "stock   = ", show(stock), "\n"
];