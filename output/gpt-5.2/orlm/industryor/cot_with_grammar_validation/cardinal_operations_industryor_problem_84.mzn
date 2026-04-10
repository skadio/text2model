int: n_products = 2;
set of int: P = 1..n_products;

int: X = 1;
int: Y = 2;

array[P] of int: machine_min_per_batch = [13, 19];
array[P] of int: craft_min_per_batch = [20, 29];

int: machine_available_min = 40 * 60;
int: craft_available_min = 35 * 60;

int: machine_cost_per_hour = 10;
int: craft_cost_per_hour = 2;

array[P] of int: revenue_per_batch = [20, 30];

int: min_batches_X = 10;

float: machine_cost_per_min = machine_cost_per_hour / 60.0;
float: craft_cost_per_min = craft_cost_per_hour / 60.0;

array[P] of var 0.0..1.0e6: batches;

var float: profit;

constraint forall(p in P) (batches[p] >= 0.0);

constraint sum(p in P)(machine_min_per_batch[p] * batches[p]) <= machine_available_min;
constraint sum(p in P)(craft_min_per_batch[p] * batches[p]) <= craft_available_min;

constraint batches[X] >= int2float(min_batches_X);

constraint profit =
  sum(p in P)(int2float(revenue_per_batch[p]) * batches[p])
  - machine_cost_per_min * sum(p in P)(int2float(machine_min_per_batch[p]) * batches[p])
  - craft_cost_per_min * sum(p in P)(int2float(craft_min_per_batch[p]) * batches[p]);

solve maximize profit;

output [
  "batches_X=", show(batches[X]), "\n",
  "batches_Y=", show(batches[Y]), "\n",
  "profit=", show(profit), "\n"
];