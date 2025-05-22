% Parameters
int: N;
int: Capacity;
int: HoldingCost;
array[1..N] of int: Price;
array[1..N] of int: Cost;

set of int: T = 1..N;

% Variables
array[T] of var 0..Capacity: Stock;   % inventory level at the end of each period
array[T] of var 0..Capacity: Buy;     % quantity bought in each period
array[T] of var 0..Capacity: Sell;    % quantity sold in each period

% Constraints

% Inventory balance
constraint Stock[1] = Buy[1] - Sell[1];
constraint forall(t in 2..N)(
    Stock[t] = Stock[t-1] + Buy[t] - Sell[t]
);

% Capacity limit
constraint forall(t in T)(
    Stock[t] <= Capacity
);

% Cannot sell more than available stock within a period
constraint Sell[1] <= Buy[1];
constraint forall(t in 2..N)(
    Sell[t] <= Stock[t-1] + Buy[t]
);

% Ending inventory must be zero
constraint Stock[N] = 0;

% Objective
solve maximize
    sum(t in T)(
        Sell[t] * Price[t]
      - Buy[t]  * Cost[t]
      - HoldingCost * Stock[t]
    );