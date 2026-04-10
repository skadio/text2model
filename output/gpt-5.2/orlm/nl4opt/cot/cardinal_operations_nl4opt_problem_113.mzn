% Parameters (with values embedded)
int: total_acres = 50;
int: min_apples = 5;
int: min_pears = 10;
int: profit_per_apple = 2;
int: profit_per_pear = 4;

% Variables
var 0..total_acres: apples;
var 0..total_acres: pears;
var 0..(profit_per_apple*total_acres + profit_per_pear*total_acres): profit;

% Constraints
constraint apples + pears <= total_acres;
constraint apples >= min_apples;
constraint pears >= min_pears;
constraint pears >= apples;          % prefers more pears than apples
constraint pears <= 2 * apples;      % workforce limitation
constraint profit = profit_per_apple * apples + profit_per_pear * pears;

% Objective
solve maximize profit;

output [
  "apples_acres=", show(apples), "\n",
  "pears_acres=", show(pears), "\n",
  "profit=", show(profit), "\n"
];