% Parameters
int: N;
int: Capacity;
int: HoldingCost;
array[1..N] of int: Price;
array[1..N] of int: Cost;

set of int: Periods = 1..N;

% Variables
array[Periods] of var 0..Capacity: buy;      % units bought in period t
array[Periods] of var 0..Capacity: sell;     % units sold  in period t
array[0..N]     of var 0..Capacity: stock;   % inventory level at end of period t
var int: profit;

% Constraints
constraint stock[0] = 0;
constraint
  forall(t in Periods)(
    stock[t] = stock[t-1] + buy[t] - sell[t]
  );
constraint stock[N] = 0;

constraint
  profit =
    sum(t in Periods)(Price[t] * sell[t])
  - sum(t in Periods)(Cost[t]  * buy[t])
  - sum(t in Periods)(HoldingCost * stock[t]);

% Objective
solve maximize profit;