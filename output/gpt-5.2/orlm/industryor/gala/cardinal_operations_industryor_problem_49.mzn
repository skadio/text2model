% Purchase & sales planning (July–December)
% Maximize total revenue (sales revenue - purchase cost)
% Inventory starts with 200 at end of June.
% Purchases occur at beginning of each month; sales during the month.
% Warehouse capacity may never exceed 500 units (after purchase and after sales).

include "globals.mzn";

int: T = 6;
set of int: M = 1..T;

array[M] of int: buyPrice  = [28,24,25,27,23,23];  % Jul..Dec
array[M] of int: sellPrice = [29,24,26,28,22,25];  % Jul..Dec

int: initStock = 200;
int: cap = 500;

% Decision variables
array[M] of var 0..cap: buy;        % units purchased at start of month
array[M] of var 0..cap: sell;       % units sold during month
array[0..T] of var 0..cap: stock;   % stock at end of each month (stock[0] = end of June)

constraint stock[0] = initStock;

% Inventory flow and capacity constraints
constraint forall(t in M) (
  let {
    var int: stock_after_buy = stock[t-1] + buy[t]
  } in
    stock_after_buy <= cap /\
    sell[t] <= stock_after_buy /\
    stock[t] = stock_after_buy - sell[t] /\
    stock[t] <= cap
);

% Objective: maximize profit over the horizon
var int: profit = sum(t in M)( sellPrice[t] * sell[t] - buyPrice[t] * buy[t] );

solve maximize profit;

output [
  "Buy prices  (Jul..Dec) = ", show(buyPrice), "\n",
  "Sell prices (Jul..Dec) = ", show(sellPrice), "\n\n",
  "Buy  (Jul..Dec) = ", show(buy), "\n",
  "Sell (Jul..Dec) = ", show(sell), "\n",
  "Stock end-of-month (Jun..Dec) = ", show(stock), "\n\n",
  "Total profit = ", show(profit), "\n"
];