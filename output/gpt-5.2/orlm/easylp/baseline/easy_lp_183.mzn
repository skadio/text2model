% Energy production cost minimization (integer quantities)

int: demand = 5000;

int: coal_cap = 3000;
int: gas_cap  = 2000;
int: nuc_cap  = 1500;

int: coal_cost = 4;
int: gas_cost  = 3;
int: nuc_cost  = 2;

var 0..coal_cap: coal;
var 0..gas_cap: gas;
var 0..nuc_cap: nuclear;

constraint coal + gas + nuclear >= demand;

var int: total_cost = coal_cost * coal + gas_cost * gas + nuc_cost * nuclear;

solve minimize total_cost;

output [
  "coal=", show(coal), "\n",
  "gas=", show(gas), "\n",
  "nuclear=", show(nuclear), "\n",
  "total_units=", show(coal + gas + nuclear), "\n",
  "min_total_cost_dollars=", show(total_cost), "\n"
];