include "globals.mzn";

% Restaurants: 1=A, 2=B, 3=C, 4=D
int: n = 4;
set of int: R = 1..n;

array[R] of int: revenue = [15000, 40000, 30000, 50000];      % annual revenue ($)
array[R] of int: cost    = [1600000, 2500000, 1800000, 3000000]; % purchase cost ($)

int: budget = 6000000;

% Decision: buy[r] = 1 if restaurant r is purchased, else 0
array[R] of var 0..1: buy;

% Budget constraint
constraint sum(r in R)(cost[r] * buy[r]) <= budget;

% If buy D then cannot buy A
constraint buy[4] = 1 -> buy[1] = 0;

% Objective: maximize total annual revenue
var int: total_revenue = sum(r in R)(revenue[r] * buy[r]);
solve maximize total_revenue;

output [
  "Buy A,B,C,D = ", show(buy), "\n",
  "Total cost = ", show(sum(r in R)(cost[r] * buy[r])), "\n",
  "Total annual revenue = ", show(total_revenue), "\n"
];