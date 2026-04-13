% Parameters (with values embedded)
int: shaping_available = 3000;
int: baking_available  = 4000;

int: shaping_thin   = 50;
int: baking_thin    = 90;
int: shaping_stubby = 30;
int: baking_stubby  = 150;

int: profit_thin   = 5;
int: profit_stubby = 9;

% Variables
var 0..(shaping_available div shaping_thin): thin_jars;
var 0..(shaping_available div shaping_stubby): stubby_jars;

% Constraints
constraint shaping_thin * thin_jars + shaping_stubby * stubby_jars <= shaping_available;
constraint baking_thin  * thin_jars + baking_stubby  * stubby_jars <= baking_available;

% Objective
var int: total_profit = profit_thin * thin_jars + profit_stubby * stubby_jars;

solve maximize total_profit;

output [
  "thin_jars=", show(thin_jars), "\n",
  "stubby_jars=", show(stubby_jars), "\n",
  "total_profit=", show(total_profit), "\n"
];