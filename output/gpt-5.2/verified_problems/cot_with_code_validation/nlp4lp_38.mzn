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

% Redundant but strengthens propagation: cannot sell more than available after buying
constraint forall(t in 1..N) (
  sell[t] <= stock[t-1] + buy[t]
);

% Capacity already enforced by stock domain 0..Capacity; keep stock nonnegative
constraint forall(t in 0..N) (
  stock[t] >= 0 /\ stock[t] <= Capacity
);

% Objective: profit = revenue - purchase costs - holding costs (for stock held after each period except last)
solve maximize
  sum(t in 1..N) (Price[t] * sell[t] - Cost[t] * buy[t])
  - sum(t in 1..N-1) (HoldingCost * stock[t]);

output [
  "buy = ", show(buy), "\n",
  "sell = ", show(sell), "\n",
  "stock = ", show(stock), "\n",
  "profit = ",
    show(
      sum(t in 1..N) (Price[t] * sell[t] - Cost[t] * buy[t])
      - sum(t in 1..N-1) (HoldingCost * stock[t])
    ), "\n"
];