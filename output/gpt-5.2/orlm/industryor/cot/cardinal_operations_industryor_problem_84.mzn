% Parameters (with values embedded)
int: nProducts = 2;
set of int: P = 1..nProducts;

int: X = 1;
int: Y = 2;

array[P] of int: machine_minutes = [13, 19];
array[P] of int: craftsman_minutes = [20, 29];

int: machine_available_hours = 40;
int: craftsman_available_hours = 35;

int: machine_available_minutes = machine_available_hours * 60;
int: craftsman_available_minutes = craftsman_available_hours * 60;

float: machine_cost_per_hour = 10.0;
float: craftsman_cost_per_hour = 2.0;

array[P] of float: revenue_per_batch = [20.0, 30.0];

int: min_batches_X = 10;

% Variables
array[P] of var float: batches;

% Constraints
constraint forall(p in P)(batches[p] >= 0.0);

constraint sum(p in P)(machine_minutes[p] * batches[p]) <= machine_available_minutes;
constraint sum(p in P)(craftsman_minutes[p] * batches[p]) <= craftsman_available_minutes;

constraint batches[X] >= float(min_batches_X);

% Objective
var float: profit =
    sum(p in P)(revenue_per_batch[p] * batches[p])
  - machine_cost_per_hour * (sum(p in P)(machine_minutes[p] * batches[p]) / 60.0)
  - craftsman_cost_per_hour * (sum(p in P)(craftsman_minutes[p] * batches[p]) / 60.0);

solve maximize profit;