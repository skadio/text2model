% Handbag production planning (integer linear optimization)
% Data embedded per problem statement.

int: profit_regular = 30;
int: profit_premium = 180;

int: cost_regular = 200;
int: cost_premium = 447;

int: budget = 250000;
int: max_total = 475;

% Decision variables: number of handbags to sell/produce
var 0..max_total: regular;
var 0..max_total: premium;

% Constraints
constraint cost_regular * regular + cost_premium * premium <= budget;
constraint regular + premium <= max_total;

% Objective: maximize monthly profit
var int: total_profit = profit_regular * regular + profit_premium * premium;

solve maximize total_profit;

output [
  "Regular = ", show(regular), "\n",
  "Premium = ", show(premium), "\n",
  "TotalProfit = ", show(total_profit), "\n",
  "TotalCost = ", show(cost_regular * regular + cost_premium * premium), "\n",
  "TotalUnits = ", show(regular + premium), "\n"
];