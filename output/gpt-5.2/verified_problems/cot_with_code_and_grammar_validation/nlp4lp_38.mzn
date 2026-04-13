% Parameters
int: N;
int: Capacity;
int: HoldingCost;
array[1..N] of int: Price;
array[1..N] of int: Cost;

% Variables
array[1..N] of var 0..Capacity: buy;
array[1..N] of var 0..Capacity: sell;
array[0..N] of var 0..Capacity: stock;

% Constraints
constraint stock[0] = 0;
constraint stock[N] = 0;

constraint forall(t in 1..N) (
  stock[t] = stock[t-1] + buy[t] - sell[t]
);

constraint forall(t in 1..N) (
  sell[t] <= stock[t-1] + buy[t]
);

% Objective
var int: profit =
  sum(t in 1..N) (Price[t] * sell[t] - Cost[t] * buy[t])
  - sum(t in 1..N-1) (HoldingCost * stock[t]);

solve maximize profit;