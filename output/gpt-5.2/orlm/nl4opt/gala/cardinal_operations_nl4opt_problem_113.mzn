% Orchard planning: maximize profit from apples and pears (acres)
% All data embedded as requested.

int: total_acres = 50;

int: min_apples = 5;
int: min_pears  = 10;

int: profit_per_apple = 2;
int: profit_per_pear  = 4;

% Decision variables (acres, assumed integer)
var 0..total_acres: apples;
var 0..total_acres: pears;

% Land availability
constraint apples + pears <= total_acres;

% Minimum demand requirements
constraint apples >= min_apples;
constraint pears  >= min_pears;

% Preference and workforce limitation
constraint pears > apples;          % prefers more pears than apples
constraint pears <= 2 * apples;     % at most twice pears as apples

% Objective: maximize profit
var int: profit = profit_per_apple * apples + profit_per_pear * pears;

solve maximize profit;

output [
  "Apples (acres) = ", show(apples), "\n",
  "Pears  (acres) = ", show(pears), "\n",
  "Profit = $", show(profit), "\n"
];