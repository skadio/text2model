% Zhang family restaurant investment (0/1 knapsack with an implication constraint)

set of int: R = 1..4;
int: A = 1; int: B = 2; int: C = 3; int: D = 4;

array[R] of int: revenue = [15000, 40000, 30000, 50000]; % annual revenue in dollars
array[R] of int: cost    = [1600000, 2500000, 1800000, 3000000]; % cost in dollars

int: budget = 6000000;

array[R] of var 0..1: buy;

constraint sum(r in R)(cost[r] * buy[r]) <= budget;

% If they purchase Restaurant D, then they cannot purchase Restaurant A.
constraint buy[D] + buy[A] <= 1;

var int: total_revenue = sum(r in R)(revenue[r] * buy[r]);
var int: total_cost    = sum(r in R)(cost[r] * buy[r]);

solve maximize total_revenue;

output [
  "Buy A: ", show(buy[A]), "\n",
  "Buy B: ", show(buy[B]), "\n",
  "Buy C: ", show(buy[C]), "\n",
  "Buy D: ", show(buy[D]), "\n",
  "Total cost: ", show(total_cost), "\n",
  "Total revenue: ", show(total_revenue), "\n"
];