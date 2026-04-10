% Mrs. Watson real-estate investment (LP)

% Parameters
int: budget = 760000;
float: profit_per_dollar_condos = 0.50;
float: profit_per_dollar_houses = 1.0;
float: min_condos_fraction = 0.20;
int: min_houses_investment = 20000;

% Variables (use float vars to avoid int/float conversions and improve solver robustness)
var 0.0..int2float(budget): invest_condos;
var 0.0..int2float(budget): invest_houses;

% Constraints
constraint invest_condos + invest_houses <= int2float(budget);

% At least 20% of total invested must be condos:
% invest_condos >= 0.2 * (invest_condos + invest_houses)  <=>  4*invest_condos >= invest_houses
constraint 4.0 * invest_condos >= invest_houses;

constraint invest_houses >= int2float(min_houses_investment);

% Objective: maximize total profit
var 0.0..(profit_per_dollar_houses * int2float(budget)): total_profit;
constraint total_profit =
    profit_per_dollar_condos * invest_condos
  + profit_per_dollar_houses * invest_houses;

solve maximize total_profit;

output [
  "invest_condos = ", show(invest_condos), "\n",
  "invest_houses = ", show(invest_houses), "\n",
  "total_profit = ", show(total_profit), "\n"
];