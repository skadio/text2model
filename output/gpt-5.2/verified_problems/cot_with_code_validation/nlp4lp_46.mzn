% Wild Sports production planning

% Parameters
int: N;
int: M;

array[1..N] of int: Available;
array[1..N, 1..M] of int: Requirements;

array[1..M] of int: Prices;
array[1..M] of int: Costs;
array[1..M] of int: Demands;

% Variables
array[1..M] of var 0..Demands[j]: Produce;

% Objective: maximize total profit
var int: Profit = sum(j in 1..M)((Prices[j] - Costs[j]) * Produce[j]);

% Constraints
constraint forall(i in 1..N) (
  sum(j in 1..M)(Requirements[i,j] * Produce[j]) <= Available[i]
);

solve maximize Profit;

output [
  "Produce = ", show(Produce), "\n",
  "Profit = ", show(Profit), "\n"
];