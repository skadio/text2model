% Grain trading over 3 months
% Purchases in month t arrive in month t and must be paid then.
% Sales in month t can only come from inventory available at start of month t
% (i.e., from previous months' purchases / initial stock), and are sold within month t.

include "globals.mzn";

int: T = 3;
set of int: M = 1..T;

int: capacity = 5000;          % warehouse capacity (dan)
int: init_stock = 1000;        % stock on Jan 1 (dan)
int: target_end_stock = 2000;  % required stock at end of March (dan)

int: init_cash = 20000;        % yuan

% Prices in fen (1/100 yuan) to keep integrality exact
array[M] of int: buyPrice  = [285, 305, 290];  % yuan/dan * 100
array[M] of int: sellPrice = [310, 325, 295];  % yuan/dan * 100

% Decision variables (dan)
array[M] of var 0..capacity: buy;
array[M] of var 0..capacity: sell;

% State variables: end-of-month inventory and cash (fen)
array[M] of var 0..capacity: invEnd;
array[M] of var 0..1000000000: cashEnd; % large enough upper bound

% Inventory flow
constraint invEnd[1] = init_stock + buy[1] - sell[1];
constraint forall(t in 2..T)(
  invEnd[t] = invEnd[t-1] + buy[t] - sell[t]
);

% Capacity each month end (and nonnegativity already from domains)
constraint forall(t in M)(invEnd[t] <= capacity);

% Sales availability: can only sell from inventory at start of month
constraint sell[1] <= init_stock;            % can't sell grains bought in month 1 within month 1
constraint forall(t in 2..T)(sell[t] <= invEnd[t-1]);

% Cash flow: pay for purchases on delivery (same month), receive sales revenue in same month
constraint cashEnd[1] = init_cash + sellPrice[1]*sell[1] - buyPrice[1]*buy[1];
constraint forall(t in 2..T)(
  cashEnd[t] = cashEnd[t-1] + sellPrice[t]*sell[t] - buyPrice[t]*buy[t]
);

% No borrowing: cash must never go negative at month end
constraint forall(t in M)(cashEnd[t] >= 0);

% End-of-quarter inventory requirement
constraint invEnd[T] = target_end_stock;

% Objective: maximize profit over the quarter (equivalently maximize ending cash,
% since initial cash is fixed and final inventory is fixed by constraint).
solve maximize cashEnd[T];

output [
  "Buy (dan)  = ", show(buy), "\n",
  "Sell (dan) = ", show(sell), "\n",
  "InvEnd     = ", show(invEnd), "\n",
  "CashEnd(yuan)= ", show([ cashEnd[t] div 100.0 | t in M ]), "\n",
  "Final cash (fen) = ", show(cashEnd[T]), "\n"
];