include "globals.mzn";

% Parameters
int: N; % The number of time periods
int: Capacity; % Maximum storage capacity
int: HoldingCost; % Cost of holding one unit of product
array[1..N] of int: Price; % Selling price in each period
array[1..N] of int: Cost; % Cost of buying in each period

% Decision variables
array[1..N] of var 0..Capacity: Buy; % Amount to buy in each period
array[1..N] of var 0..Capacity: Sell; % Amount to sell in each period
array[1..N] of var 0..Capacity: Stock; % Amount of stock in each period

% Constraints
constraint Stock[1] = Buy[1] - Sell[1];
constraint forall(i in 2..N) (Stock[i] = Stock[i-1] + Buy[i] - Sell[i]);
constraint forall(i in 1..N) (Stock[i] <= Capacity);
constraint Stock[N] = 0;

% Objective function
var int: Profit = sum(i in 1..N) (Price[i]*Sell[i] - Cost[i]*Buy[i] - HoldingCost*Stock[i]);
solve maximize Profit;

% Output
output ["Profit: ", show(Profit), "\n"] ++
["Buy: "] ++ [show(Buy[i]) | i in 1..N] ++ ["\n"] ++
["Sell: "] ++ [show(Sell[i]) | i in 1..N] ++ ["\n"] ++
["Stock: "] ++ [show(Stock[i]) | i in 1..N] ++ ["\n"];