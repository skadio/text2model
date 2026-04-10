% Purchase & sales plan (July..December)

int: n_months = 6;
set of int: MONTHS = 1..n_months;           % 1=Jul, ..., 6=Dec

int: capacity = 500;
int: initial_stock = 200;

array[MONTHS] of int: buy_price  = [28, 24, 25, 27, 23, 23];
array[MONTHS] of int: sell_price = [29, 24, 26, 28, 22, 25];

% Decision variables (tight bounds to avoid search blow-up / timeout)
% Purchases at beginning of month m:
% cannot exceed remaining capacity given starting stock that month.
array[MONTHS] of var 0..capacity: purchase;

% Sales during month m:
% cannot exceed available stock that month (initial_stock + all purchases up to m).
array[MONTHS] of var 0..(initial_stock + n_months * capacity): sale;

% End-of-month stock, with stock[0] being end of June.
array[0..n_months] of var 0..capacity: stock;

constraint stock[0] = initial_stock;

% Inventory balance
constraint forall(m in MONTHS) (
  stock[m] = stock[m-1] + purchase[m] - sale[m]
);

% Capacity applies immediately after purchasing as well (beginning-of-month)
constraint forall(m in MONTHS) (
  stock[m-1] + purchase[m] <= capacity
);

% Cannot sell more than available during the month
constraint forall(m in MONTHS) (
  sale[m] <= stock[m-1] + purchase[m]
);

solve maximize
  sum(m in MONTHS) (sell_price[m] * sale[m] - buy_price[m] * purchase[m]);

output [
  "purchase = ", show(purchase), "\n",
  "sale     = ", show(sale), "\n",
  "stock    = ", show(stock), "\n",
  "profit   = ", show(sum(m in MONTHS) (sell_price[m] * sale[m] - buy_price[m] * purchase[m])), "\n"
];