include "globals.mzn";

%--------------------------
% Input data
%--------------------------
int: N;                          % number of periods
int: Capacity;                   % max inventory
int: HoldingCost;                % cost per unit carried from t to t+1
array[1..N] of int: Price;       % selling price per unit in period t
array[1..N] of int: Cost;        % buying cost per unit in period t

%--------------------------
% Decision variables
%--------------------------
array[1..N] of var 0..Capacity: buy;     % units bought in period t
array[1..N] of var 0..Capacity: sell;    % units sold in period t
array[0..N] of var 0..Capacity: stock;   % inventory at end of period t

%--------------------------
% Constraints
%--------------------------
constraint stock[0] = 0;          % initially empty
constraint stock[N] = 0;          % must be empty at end

% Inventory balance and capacity bounds
constraint forall(t in 1..N) (
  stock[t] = stock[t-1] + buy[t] - sell[t]
);

% Can't sell more than available during the period
constraint forall(t in 1..N) (
  sell[t] <= stock[t-1] + buy[t]
);

%--------------------------
% Objective: maximize profit
% Profit = revenue from sales - cost of purchases - holding cost on end-of-period stock
% Holding cost applies for holding from period t to t+1, i.e., stock[1..N-1]
%--------------------------
var int: profit =
  sum(t in 1..N)( Price[t] * sell[t] - Cost[t] * buy[t] )
  - HoldingCost * sum(t in 1..N-1)( stock[t] );

solve maximize profit;

%--------------------------
% Output
%--------------------------
output [
  "profit = ", show(profit), "\n",
  "buy    = ", show(buy), "\n",
  "sell   = ", show(sell), "\n",
  "stock  = ", show(stock), "\n"
];