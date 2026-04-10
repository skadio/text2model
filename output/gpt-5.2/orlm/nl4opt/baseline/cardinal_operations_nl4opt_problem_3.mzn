% Ice cream machine purchasing problem
% Minimize number of machines while meeting production and heat constraints.

int: prod_counter = 80;
int: prod_fridge  = 150;

int: heat_counter = 50;
int: heat_fridge  = 70;

int: max_heat = 500;
int: min_cones = 1000;

% Decision variables: number of each machine to buy
var 0..(max_heat div heat_counter): counter_machines;
var 0..(max_heat div heat_fridge):  fridge_machines;

constraint
  prod_counter * counter_machines + prod_fridge * fridge_machines >= min_cones;

constraint
  heat_counter * counter_machines + heat_fridge * fridge_machines <= max_heat;

var int: total_machines = counter_machines + fridge_machines;

solve minimize total_machines;

output [
  "counter_machines = ", show(counter_machines), "\n",
  "fridge_machines = ",  show(fridge_machines),  "\n",
  "total_machines = ",   show(total_machines),   "\n",
  "total_cones = ", show(prod_counter*counter_machines + prod_fridge*fridge_machines), "\n",
  "total_heat = ", show(heat_counter*counter_machines + heat_fridge*fridge_machines), "\n"
];