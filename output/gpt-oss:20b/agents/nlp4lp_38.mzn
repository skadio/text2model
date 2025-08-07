include "globals.mzn";

% ----- data ---------------------------------------------------------
int: N;                 % number of periods
int: Capacity;          % maximum storage capacity
int: HoldingCost;       % cost per unit per period

array[1..N] of int: Price;   % selling price per period
array[1..N] of int: Cost;    % buying cost per period

% ----- decision variables -----------------------------------------
array[1..N] of var 0..Capacity: buy;     % units bought in each period
array[1..N] of var 0..Capacity: sell;    % units sold  in each period
array[1..N] of var 0..Capacity: inv;     % inventory at end of each period

% ----- inventory dynamics ------------------------------------------
constraint inv[1] = buy[1] - sell[1];
constraint forall(i in 2..N)(
    inv[i] = inv[i-1] + buy[i] - sell[i]
);

% ----- final inventory must be empty -----------------------------
constraint inv[N] = 0;

% ----- objective: maximize profit ---------------------------------
var int: profit = sum(i in 1..N) (
    Price[i] * sell[i] - Cost[i] * buy[i] - HoldingCost * inv[i]
);

solve maximize profit;

% ----- output -------------------------------------------------------
output [
    "Profit = ", show(profit), "\n",
    "Buy    = ", show(buy),   "\n",
    "Sell   = ", show(sell),  "\n",
    "Inventory = ", show(inv), "\n"
];