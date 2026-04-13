int: demand = 1000;

int: cost_coal = 50;
int: cost_gas = 40;
int: cost_nuclear = 60;

var 0..100000: coal;
var 0..100000: gas;
var 0..100000: nuclear;

constraint coal + gas + nuclear >= demand;
constraint 3 * coal - gas <= 500;
constraint nuclear >= 200 + 2 * gas;

var int: total_cost = cost_coal * coal + cost_gas * gas + cost_nuclear * nuclear;

solve minimize total_cost;

output [
  "coal = ", show(coal), "\n",
  "gas = ", show(gas), "\n",
  "nuclear = ", show(nuclear), "\n",
  "minimum_total_cost = $", show(total_cost), "\n"
];