% Commercial real estate selection (0/1 knapsack with conflict)

int: n = 4;
set of int: P = 1..n;

array[P] of int: income = [12500, 35000, 23000, 100000];

% Costs in dollars
array[P] of int: cost = [1500000, 2100000, 2300000, 4200000];
int: budget = 7000000;

array[P] of var 0..1: buy;

constraint sum(p in P)(cost[p] * buy[p]) <= budget;

% If they purchase Property 4, they cannot purchase Property 3
constraint buy[4] + buy[3] <= 1;

var int: total_income = sum(p in P)(income[p] * buy[p]);

solve maximize total_income;

output [
  "Buy decisions (1=yes, 0=no):\n",
  concat([ "Property ", show(p), ": ", show(buy[p]), "\n" | p in P ]),
  "Total cost: $", show(sum(p in P)(cost[p] * buy[p])), "\n",
  "Total annual income: $", show(total_income), "\n"
];