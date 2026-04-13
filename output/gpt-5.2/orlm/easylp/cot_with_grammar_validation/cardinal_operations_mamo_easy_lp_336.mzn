int: cost_coal = 10;
int: cost_gas = 15;
int: cost_nuclear = 20;
int: cost_solar = 25;

int: min_coal_gas = 400;
int: max_diff_nuclear_solar = 100;
int: min_coal_minus_nuclear = 200;
int: min_gas_solar = 500;

var 0..100000: coal;
var 0..100000: gas;
var 0..100000: nuclear;
var 0..100000: solar;

var 0..10000000: total_cost;

constraint coal + gas >= min_coal_gas;
constraint abs(nuclear - solar) <= max_diff_nuclear_solar;
constraint coal - nuclear >= min_coal_minus_nuclear;
constraint gas + solar >= min_gas_solar;

constraint total_cost =
  cost_coal * coal +
  cost_gas * gas +
  cost_nuclear * nuclear +
  cost_solar * solar;

solve minimize total_cost;

output ["minimum_total_cost=", show(total_cost), "\n"];