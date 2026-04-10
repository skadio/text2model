% Parameters
int: N;                              % Number of time periods
set of int: T = 1..N;                % Time index set

int: Capacity;                       % Maximum warehouse storage capacity (units)
int: HoldingCost;                    % Holding cost per unit per period

array[T] of int: Price;              % Selling price per unit in each period
array[T] of int: Cost;               % Buying cost per unit in each period


% Variables
array[T] of var 0..Capacity: stock;  % Inventory level at end of each period (bounded by capacity)
array[T] of var 0..Capacity: buy;    % Units bought in each period (bounded by capacity)
array[T] of var 0..Capacity: sell;   % Units sold in each period (bounded by capacity)


% Constraints

% Inventory balance (stock flow conservation)
% stock[t] = stock[t-1] + buy[t] - sell[t], with stock[0] = 0
constraint stock[1] = buy[1] - sell[1];

constraint
  forall(t in 2..N) (
    stock[t] = stock[t-1] + buy[t] - sell[t]
  );

% Warehouse starts empty and must end empty (starts empty is implied by stock[1] equation with stock[0]=0)
constraint stock[N] = 0;

% Cannot sell more than available inventory in the same period
constraint sell[1] <= buy[1];

constraint
  forall(t in 2..N) (
    sell[t] <= stock[t-1] + buy[t]
  );

% Capacity consistency (redundant with variable domains, kept for clarity/maintenance)
constraint
  forall(t in T) (
    stock[t] <= Capacity /\ buy[t] <= Capacity /\ sell[t] <= Capacity
  );


% Objective
solve maximize
  sum(t in T) (Price[t] * sell[t] - Cost[t] * buy[t] - HoldingCost * stock[t]);