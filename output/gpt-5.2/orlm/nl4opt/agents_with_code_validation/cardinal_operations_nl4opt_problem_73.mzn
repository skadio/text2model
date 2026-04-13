% Investment optimization (all data embedded)

% Parameters
int: total_budget = 100000;
int: telecom_max = 70000;
int: ratio = 3;                 % telecom >= 3 * healthcare

int: telecom_rate_pct = 3;      % 3%
int: healthcare_rate_pct = 1;   % 1%

% Decision variables (in dollars)
var 0..telecom_max: invest_telecom;
var 0..total_budget: invest_healthcare;

% Constraints
constraint invest_telecom + invest_healthcare <= total_budget;
constraint invest_telecom >= ratio * invest_healthcare;

% Use integer profit in cents to avoid floats (faster, avoids timeout)
% profit_cents = (3% of telecom + 1% of healthcare) dollars, converted to cents
var 0..300000000: profit_cents;
constraint profit_cents = 3 * invest_telecom + 1 * invest_healthcare;

% Objective
solve maximize profit_cents;

output [
  "invest_telecom = ", show(invest_telecom), "\n",
  "invest_healthcare = ", show(invest_healthcare), "\n",
  "profit = $", show(profit_cents div 100), ".", show((profit_cents mod 100) div 10), show(profit_cents mod 10), "\n"
];