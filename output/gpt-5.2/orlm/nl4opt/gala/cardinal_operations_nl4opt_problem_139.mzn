include "globals.mzn";

% Data (embedded)
int: eggs_available = 40;
int: bacon_available = 70;

int: eggs_regular = 2;
int: bacon_regular = 3;
int: profit_regular = 3;

int: eggs_special = 3;
int: bacon_special = 5;
int: profit_special = 4;

% Decision variables: number of sandwiches to make
var 0..min(eggs_available div eggs_regular, bacon_available div bacon_regular): regular;
var 0..min(eggs_available div eggs_special, bacon_available div bacon_special): special;

% Resource constraints
constraint eggs_regular * regular + eggs_special * special <= eggs_available;
constraint bacon_regular * regular + bacon_special * special <= bacon_available;

% Objective: maximize total profit
var int: total_profit = profit_regular * regular + profit_special * special;

solve maximize total_profit;

output [
  "Regular sandwiches = ", show(regular), "\n",
  "Special sandwiches = ", show(special), "\n",
  "Total profit = $", show(total_profit), "\n"
];