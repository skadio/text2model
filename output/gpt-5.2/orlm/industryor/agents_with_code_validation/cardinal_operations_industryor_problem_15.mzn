% Purchasing & sales plan (LP/MIP) - embedded data

% Parameters
int: nMonths = 3;
set of int: MONTHS = 1..nMonths;

int: capacity = 500;
int: initial_stock = 200;

array[MONTHS] of int: purchase_price = [8, 6, 9];
array[MONTHS] of int: sell_price     = [9, 8, 10];

% Variables (use unbounded nonnegative ints with explicit constraints to help solvers)
array[MONTHS] of var int: buy;
array[MONTHS] of var int: sell;
array[0..nMonths] of var int: inv;

% Basic domains
constraint inv[0] = initial_stock;
constraint forall(m in MONTHS) (buy[m] >= 0 /\ sell[m] >= 0);
constraint forall(m in 0..nMonths) (inv[m] >= 0 /\ inv[m] <= capacity);

% Inventory flow: end inventory = start inventory + purchases - sales
constraint forall(m in MONTHS) (
  inv[m] = inv[m-1] + buy[m] - sell[m]
);

% Sales cannot exceed available stock in the month
constraint forall(m in MONTHS) (
  sell[m] <= inv[m-1] + buy[m]
);

% Objective: maximize total profit
solve maximize sum(m in MONTHS) (sell_price[m] * sell[m] - purchase_price[m] * buy[m]);

% Output
output [
  "buy = ", show(buy), "\n",
  "sell = ", show(sell), "\n",
  "inv = ", show(inv), "\n",
  "profit = ", show(sum(m in MONTHS) (sell_price[m] * sell[m] - purchase_price[m] * buy[m])), "\n"
];