% Orchard planning: maximize profit from apples and pears

int: total_acres = 50;

int: min_apples = 5;
int: min_pears  = 10;

int: profit_per_apple = 2;
int: profit_per_pear  = 4;

var int: apples >= min_apples;
var int: pears  >= min_pears;

constraint apples + pears <= total_acres;
constraint pears > apples;          % prefers more pears than apples
constraint pears <= 2 * apples;     % workforce limitation

var int: profit = profit_per_apple * apples + profit_per_pear * pears;

solve maximize profit;

output [
  "apples_acres=", show(apples), "\n",
  "pears_acres=", show(pears), "\n",
  "profit=", show(profit), "\n"
];