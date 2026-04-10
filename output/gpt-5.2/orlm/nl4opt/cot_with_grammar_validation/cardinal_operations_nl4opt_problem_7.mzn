float: profit_chair = 43.0;
float: profit_dresser = 52.0;

float: stain_available = 17.0;
int: wood_available = 11;

float: stain_per_chair = 1.4;
float: stain_per_dresser = 1.1;

int: wood_per_chair = 2;
int: wood_per_dresser = 3;

var 0..100: chairs;
var 0..100: dressers;

var float: total_profit;

constraint stain_per_chair * int2float(chairs) + stain_per_dresser * int2float(dressers) <= stain_available;
constraint wood_per_chair * chairs + wood_per_dresser * dressers <= wood_available;

constraint total_profit = profit_chair * int2float(chairs) + profit_dresser * int2float(dressers);

solve maximize total_profit;

output [
  "chairs=", show(chairs), "\n",
  "dressers=", show(dressers), "\n",
  "total_profit=", show(total_profit), "\n"
];