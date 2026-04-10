int: eggs_available = 40;
int: bacon_available = 70;

int: eggs_regular = 2;
int: bacon_regular = 3;
int: eggs_special = 3;
int: bacon_special = 5;

int: profit_regular = 3;
int: profit_special = 4;

var 0..eggs_available div eggs_regular: regular;
var 0..eggs_available div eggs_special: special;

constraint eggs_regular * regular + eggs_special * special <= eggs_available;
constraint bacon_regular * regular + bacon_special * special <= bacon_available;

var int: profit = profit_regular * regular + profit_special * special;

solve maximize profit;

output [
  "regular=", show(regular), "\n",
  "special=", show(special), "\n",
  "profit=", show(profit), "\n"
];