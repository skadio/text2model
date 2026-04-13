int: cost_raw = 5;
int: cost_labor = 10;

var int: raw;
var int: labor;

constraint 2*raw + 3*labor >= 20;
constraint raw - labor <= 30;
constraint labor - raw <= 30;
constraint raw + labor == 100;

var int: total_cost = cost_raw * raw + cost_labor * labor;

solve minimize total_cost;

output [
  "raw=", show(raw), "\n",
  "labor=", show(labor), "\n",
  "total_cost=", show(total_cost), "\n"
];