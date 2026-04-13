int: N;                          % Number of time periods
int: Capacity;                   % Maximum storage capacity
int: HoldingCost;                % Cost of holding one unit of product
array[1..N] of int: Price;      % Selling price in each period
array[1..N] of int: Cost;       % Cost of buying in each period

/* Variables */
array[1..N] of var 0..Capacity: stock;  % Stock at the end of each period
array[1..N] of var 0..Capacity: buy;    % Amount bought in each period
array[1..N] of var 0..Capacity: sell;   % Amount sold in each period

/* Constraints */
constraint stock[1] = buy[1] - sell[1];  % Initial stock after first period
constraint forall(t in 2..N) (
    stock[t-1] + buy[t] - sell[t] = stock[t]  % Stock balance for each period
);

constraint forall(t in 1..N) (
    stock[t] >= 0 /\ stock[t] <= Capacity  % Stock must be within capacity
);

/* Final constraint: warehouse must be empty at the end */
constraint stock[N] = 0;

/* Objective: Maximize profit */
var int: profit = sum(t in 1..N) (
    Price[t] * sell[t] - Cost[t] * buy[t] - HoldingCost * stock[t]
);

solve maximize profit;

/* Output */
output [
    "Profit = ", show(profit), "\n",
    "Buy = ", show(buy), "\n",
    "Sell = ", show(sell), "\n",
    "Stock = ", show(stock), "\n"
];