% Parameters (with values embedded)
int: T = 3;
set of int: Months = 1..T;

int: capacity = 5000;

int: init_inventory = 1000;
int: target_end_inventory = 2000;

int: init_cash = 20000;

% Prices are given with decimals; scale by 100 to keep everything integer
array[Months] of int: buy_price  = [285, 305, 290];  % yuan*100 per dan
array[Months] of int: sell_price = [310, 325, 295];  % yuan*100 per dan

% Variables
array[Months] of var 0..capacity: buy;   % dan bought in month t (delivered in month t)
array[Months] of var 0..capacity: sell;  % dan sold in month t (must come from inventory available to sell)

array[0..T] of var 0..capacity: inv_end;      % inventory at end of month t
array[0..T] of var 0..intmax: cash_end;       % cash at end of month t (scaled yuan*100)

% Constraints
constraint inv_end[0] = init_inventory;
constraint cash_end[0] = init_cash * 100;

% Inventory flow:
% - buying in month t arrives immediately and can be stored
% - selling in month t can only use inventory that existed at end of month t-1
constraint forall(t in Months) (
    inv_end[t] = inv_end[t-1] + buy[t] - sell[t]
);

% Selling delay: goods bought in month t cannot be sold until month t+1
constraint forall(t in Months) (
    sell[t] <= inv_end[t-1]
);

% Capacity
constraint forall(t in 0..T) (inv_end[t] <= capacity);

% Cash flow (payment on delivery, revenue on sale)
constraint forall(t in Months) (
    cash_end[t] = cash_end[t-1] - buy_price[t] * buy[t] + sell_price[t] * sell[t]
);

% Cannot spend more cash than available (no borrowing)
constraint forall(t in Months) (
    buy_price[t] * buy[t] <= cash_end[t-1]
);

% End-of-quarter inventory requirement
constraint inv_end[T] = target_end_inventory;

% Objective
var int: profit = cash_end[T] - cash_end[0];
solve maximize profit;