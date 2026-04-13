% Mr. Roberts investment optimization (embedded data)

% Data (all amounts in dollars)
int: budget = 100000;
int: telecom_max = 70000;

% Decision variables: amounts invested
var 0..telecom_max: telecom;
var 0..budget: healthcare;

% Constraints
constraint telecom + healthcare <= budget;
constraint telecom >= 3 * healthcare;

% Profit = 3% of telecom + 1% of healthcare
% Use integer cents to keep everything integral:
% profit_cents = 3% * telecom + 1% * healthcare, multiplied by 100 => 3*telecom + 1*healthcare
var 0..(3*telecom_max + budget): profit_units;
constraint profit_units = 3*telecom + healthcare;

solve maximize profit_units;

output [
  "Telecom investment = $", show(telecom), "\n",
  "Healthcare investment = $", show(healthcare), "\n",
  "Total invested = $", show(telecom + healthcare), "\n",
  "Profit (units = 1% of $1, i.e., $0.01) = ", show(profit_units), "\n",
  "Profit in dollars = $", show(profit_units div 100), ".", show(profit_units mod 100), "\n"
];