% Commercial real estate investment (0/1 knapsack with an incompatibility)
include "globals.mzn";

int: n = 4;

array[1..n] of int: income = [12500, 35000, 23000, 100000];
array[1..n] of int: cost   = [1500000, 2100000, 2300000, 4200000];
int: budget = 7000000;

% Decision: buy[i] = 1 if Property i is purchased
array[1..n] of var 0..1: buy;

% Budget constraint
constraint sum(i in 1..n)(cost[i] * buy[i]) <= budget;

% If they purchase Property 4, they cannot purchase Property 3
constraint buy[4] + buy[3] <= 1;

% Objective: maximize annual income
var int: total_income = sum(i in 1..n)(income[i] * buy[i]);
solve maximize total_income;

output [
  "Buy decisions (1=yes,0=no) = ", show(buy), "\n",
  "Total cost = ", show(sum(i in 1..n)(cost[i] * buy[i])), "\n",
  "Total income = ", show(total_income), "\n"
];