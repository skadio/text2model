int: paint_avail = 100;
int: glitter_avail = 50;
int: glue_avail = 70;

int: paint_large = 4;
int: glitter_large = 3;
int: glue_large = 5;

int: paint_small = 2;
int: glitter_small = 1;
int: glue_small = 2;

int: min_large = 5;
int: min_small = 5;

int: profit_large = 30;
int: profit_small = 15;

var int: large;
var int: small;

constraint large >= min_large;
constraint small >= min_small;

constraint paint_large * large + paint_small * small <= paint_avail;
constraint glitter_large * large + glitter_small * small <= glitter_avail;
constraint glue_large * large + glue_small * small <= glue_avail;

var int: total_profit = profit_large * large + profit_small * small;

solve maximize total_profit;

output [
  "Large pieces: ", show(large), "\n",
  "Small pieces: ", show(small), "\n",
  "Total profit: $", show(total_profit), "\n"
];