% Parameters
int: N;
int: Capacity;
int: HoldingCost;
array[1..N] of int: Price;
array[1..N] of int: Cost;

% Variables
array[0..N] of var 0..Capacity: Inv;      % inventory at the end of each period
array[1..N] of var 0..Capacity: Buy;      % units bought in each period
array[1..N] of var 0..Capacity: Sell;     % units sold in each period
var int: Profit;                          % total profit

% Constraints
constraint Inv[0] = 0;                    % warehouse starts empty

constraint forall(t in 1..N)(
    Inv[t] = Inv[t-1] + Buy[t] - Sell[t]  % inventory balance
);

constraint Inv[N] = 0;                    % warehouse ends empty

% Objective
constraint Profit = sum(t in 1..N)(
        Sell[t] * Price[t]
      - Buy[t]  * Cost[t]
      - HoldingCost * Inv[t]               % holding cost on end-of-period inventory
);

solve maximize Profit;