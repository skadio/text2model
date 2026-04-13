% Purchasing & sales plan for one product over 3 months (Q1)
% Maximize profit with inventory balance and warehouse capacity.

include "globals.mzn";

int: T = 3;
set of int: Months = 1..T;

int: capacity = 500;
int: init_stock = 200;

array[Months] of int: buy_price  = [8, 6, 9];
array[Months] of int: sell_price = [9, 8, 10];

% Upper bound on monthly decisions (safe big-M bounds)
int: MAX_Q = capacity; % can't hold more than capacity, so buying/selling bounded by this

% Decision variables:
array[Months] of var 0..MAX_Q: buy;     % units purchased at beginning of month t
array[Months] of var 0..MAX_Q: sell;    % units sold during month t
array[0..T]    of var 0..capacity: inv; % inventory at end of month t (inv[0] is initial)

% Initial inventory
constraint inv[0] = init_stock;

% Inventory flow and feasibility
constraint forall(t in Months)(
  inv[t] = inv[t-1] + buy[t] - sell[t]
);

% Cannot sell more than available (start inventory + purchase)
constraint forall(t in Months)(
  sell[t] <= inv[t-1] + buy[t]
);

% Warehouse capacity already enforced by inv domain, but keep explicit if desired
constraint forall(t in Months)(inv[t] <= capacity);

% Objective: maximize total profit = revenue - purchase costs
var int: profit =
  sum(t in Months)(sell_price[t] * sell[t] - buy_price[t] * buy[t]);

solve maximize profit;

output [
  "Profit = ", show(profit), "\n",
  "Buy  = ", show(buy), "\n",
  "Sell = ", show(sell), "\n",
  "Inv  = ", show(inv), "\n"
];