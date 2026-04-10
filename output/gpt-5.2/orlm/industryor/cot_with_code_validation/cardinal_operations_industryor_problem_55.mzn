% Grain trading plan (3 months) - maximize profit
% Use integer "cents" (here: fen) to avoid floats.

int: T = 3;
set of int: M = 1..T;

int: capacity = 5000;

int: init_stock = 1000;
int: final_stock_req = 2000;

int: init_cash_c = 20000 * 100; % yuan -> cents

array[M] of int: buy_price_c  = [285, 305, 290];
array[M] of int: sell_price_c = [310, 325, 295];

% Tighten bounds to avoid timeout / huge search.
% Purchases are limited by storage space at time of purchase and available cash.
int: max_buy_overall = min(
  capacity,                                  % cannot buy more than warehouse capacity in a month anyway
  max([ init_cash_c div buy_price_c[m] | m in M ]) % even in best case, cannot buy more than this using initial cash
);

array[M] of var 0..max_buy_overall: buy;
array[M] of var 0..capacity: sell;

array[0..T] of var 0..capacity: stock;
array[0..T] of var 0..(init_cash_c + capacity * max(sell_price_c)): cash_c;

var int: profit_c;

% Initial conditions
constraint stock[0] = init_stock;
constraint cash_c[0] = init_cash_c;

% No selling in month 1 (cannot sell until next month)
constraint sell[1] = 0;

% Inventory balance and capacity
constraint forall(m in M) (
  stock[m] = stock[m-1] + buy[m] - sell[m]
);
constraint forall(m in M) ( stock[m] <= capacity );

% Enforce "can only sell next month": in month m>=2, sell only from previous stock
constraint forall(m in 2..T) ( sell[m] <= stock[m-1] );

% Cash flow
constraint forall(m in M) (
  cash_c[m] = cash_c[m-1]
              - buy[m] * buy_price_c[m]
              + sell[m] * sell_price_c[m]
);

% Can't spend money you don't have
constraint forall(m in M) ( cash_c[m] >= 0 );

% Also ensure purchases are affordable at time of purchase (redundant but helps propagation)
constraint forall(m in M) (
  buy[m] * buy_price_c[m] <= cash_c[m-1] + sell[m] * sell_price_c[m]
);

% Storage limit at purchase time (also helps propagation)
constraint forall(m in M) ( buy[m] <= capacity - stock[m-1] + sell[m] );

% Final inventory requirement
constraint stock[T] = final_stock_req;

% Profit = final cash - initial cash
constraint profit_c = cash_c[T] - cash_c[0];

solve :: int_search([buy[m] | m in M] ++ [sell[m] | m in M], first_fail, indomain_max, complete)
maximize profit_c;

output [
  "profit(yuan)=", show(profit_c div 100), ".", show(profit_c mod 100), "\n",
  "buy=", show(buy), "\n",
  "sell=", show(sell), "\n",
  "stock=", show(stock), "\n",
  "cash(yuan)=", show([cash_c[t] div 100 | t in 0..T]), "\n"
];