% Parameters (with values embedded)
int: total_budget = 100000;
int: telecom_max = 70000;
int: telecom_return = 3;      % percent
int: healthcare_return = 1;   % percent

% Variables
var 0..telecom_max: telecom;
var 0..total_budget: healthcare;

% Constraints
constraint telecom + healthcare <= total_budget;
constraint telecom >= 3 * healthcare;

% Objective
var int: profit = telecom_return * telecom + healthcare_return * healthcare;
solve maximize profit;

output [
  "telecom = $", show(telecom), "\n",
  "healthcare = $", show(healthcare), "\n",
  "profit (in percent-dollars) = ", show(profit), "\n"
];