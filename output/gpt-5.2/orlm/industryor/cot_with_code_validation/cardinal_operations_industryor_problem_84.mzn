% Linear profit maximization model (fractional batches allowed)
% Uses LP solving to avoid float-linear limitations in CP solvers like Gecode.
include "float.mzn";

% Products
int: num_products = 2;
set of int: P = 1..num_products;
int: X = 1;
int: Y = 2;

% Data (minutes per batch)
array[P] of float: machine_min_per_batch = [13.0, 19.0];
array[P] of float: craft_min_per_batch   = [20.0, 29.0];

% Available time (minutes)
float: machine_minutes_avail = 40.0 * 60.0; % 40 hours
float: craft_minutes_avail   = 35.0 * 60.0; % 35 hours

% Costs and revenues
float: machine_cost_per_hour = 10.0;
float: craft_cost_per_hour   = 2.0;
array[P] of float: revenue_per_batch = [20.0, 30.0];

float: min_batches_X = 10.0;

% Decision variables (batches can be fractional)
array[P] of var float: batches;
var float: profit;

% Constraints
constraint forall(p in P) (batches[p] >= 0.0);

constraint sum(p in P) (machine_min_per_batch[p] * batches[p]) <= machine_minutes_avail;
constraint sum(p in P) (craft_min_per_batch[p] * batches[p]) <= craft_minutes_avail;

constraint batches[X] >= min_batches_X;

% Objective expression
constraint
  profit =
    sum(p in P) (revenue_per_batch[p] * batches[p])
    - machine_cost_per_hour * (sum(p in P) (machine_min_per_batch[p] * batches[p]) / 60.0)
    - craft_cost_per_hour * (sum(p in P) (craft_min_per_batch[p] * batches[p]) / 60.0);

solve maximize profit;

output [
  "batches_X=", show(batches[X]), "\n",
  "batches_Y=", show(batches[Y]), "\n",
  "profit=", show(profit), "\n"
];