% Platinum Database subscription packages optimization
% Maximize profit subject to demand and budget constraints

int: max_total_licenses = 300;

int: cost_personal = 550;
int: cost_commercial = 2000;
int: max_spend = 400000;

int: profit_personal = 450;
int: profit_commercial = 1200;

% Decision variables: number of licenses to produce/sell
var 0..max_total_licenses: personal;
var 0..max_total_licenses: commercial;

% Constraints
constraint personal + commercial <= max_total_licenses;
constraint cost_personal * personal + cost_commercial * commercial <= max_spend;

% Objective: maximize total profit
var int: total_profit = profit_personal * personal + profit_commercial * commercial;

solve maximize total_profit;

output [
  "personal = ", show(personal), "\n",
  "commercial = ", show(commercial), "\n",
  "total_spend = ", show(cost_personal * personal + cost_commercial * commercial), "\n",
  "total_profit = ", show(total_profit), "\n"
];