% Parameters
set of int: PRODUCTS = 1..2;              % 1 = X, 2 = Y
array[PRODUCTS] of string: prod_name = ["X","Y"];

array[PRODUCTS] of float: machine_min_per_batch = [13.0, 19.0];
array[PRODUCTS] of float: craftsman_min_per_batch = [20.0, 29.0];

float: machine_hours_available = 40.0;
float: craftsman_hours_available = 35.0;

float: machine_cost_per_hour = 10.0;
float: craftsman_cost_per_hour = 2.0;

array[PRODUCTS] of float: revenue_per_batch = [20.0, 30.0];

float: min_batches_X = 10.0;              % contract minimum for product X

% Derived parameters (unit conversions)
float: minutes_per_hour = 60.0;
float: machine_minutes_available = machine_hours_available * minutes_per_hour;
float: craftsman_minutes_available = craftsman_hours_available * minutes_per_hour;

float: machine_cost_per_minute = machine_cost_per_hour / minutes_per_hour;
float: craftsman_cost_per_minute = craftsman_cost_per_hour / minutes_per_hour;


% Variables
array[PRODUCTS] of var float: batches;    % production quantities (fractional batches allowed)

var float: total_machine_minutes_used;    % total machine minutes used
var float: total_craftsman_minutes_used;  % total craftsman minutes used

var float: total_revenue;                 % total weekly revenue
var float: total_cost;                    % total weekly resource cost
var float: profit;                        % objective value (maximize)


% Constraints
% Resource usage definitions (link totals to per-product production)
constraint total_machine_minutes_used =
  sum(p in PRODUCTS)(machine_min_per_batch[p] * batches[p]);

constraint total_craftsman_minutes_used =
  sum(p in PRODUCTS)(craftsman_min_per_batch[p] * batches[p]);

% Resource capacity limits (available minutes in the week)
constraint total_machine_minutes_used <= machine_minutes_available;
constraint total_craftsman_minutes_used <= craftsman_minutes_available;

% Production feasibility (non-negativity)
constraint forall(p in PRODUCTS) (batches[p] >= 0.0);

% Contract requirement (minimum production of product X)
constraint batches[1] >= min_batches_X;

% Financial definitions (revenue, cost, and profit)
constraint total_revenue =
  sum(p in PRODUCTS)(revenue_per_batch[p] * batches[p]);

constraint total_cost =
  machine_cost_per_minute * total_machine_minutes_used
  + craftsman_cost_per_minute * total_craftsman_minutes_used;

constraint profit = total_revenue - total_cost;


% Objective
solve maximize profit;