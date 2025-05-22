% Parameters
int: N; % The number of time periods
int: Capacity; % Maximum storage capacity
int: HoldingCost; % Cost of holding one unit of product
array[1..N] of int: Price; % Selling price in each period
array[1..N] of int: Cost; % Cost of buying in each period

% Variables
array[1..N] of var 0..Capacity: Buy; % Amount of product bought in each period
array[1..N] of var 0..Capacity: Sell; % Amount of product sold in each period
array[1..N] of var 0..Capacity: Stock; % Amount of product in stock in each period

% Constraints
constraint Stock[1] = Buy[1] - Sell[1];
constraint forall(i in 2..N)(Stock[i] = Stock[i-1] + Buy[i] - Sell[i]);
constraint forall(i in 1..N)(Stock[i] <= Capacity);
constraint forall(i in 1..N)(Sell[i] <= Stock[i]);
constraint Stock[N] = 0;

% Objective
var int: Profit = sum(i in 1..N)(Price[i]*Sell[i] - Cost[i]*Buy[i] - HoldingCost*Stock[i]);
solve maximize Profit;