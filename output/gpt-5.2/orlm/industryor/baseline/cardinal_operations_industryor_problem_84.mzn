% Linear Programming model for weekly production plan (fractional batches allowed)

%-----------------------------
% Data (embedded)
%-----------------------------
set of int: P = 1..2;
int: X = 1;
int: Y = 2;

array[P] of string: name = ["X","Y"];

% Minutes required per batch
array[P] of float: machine_min = [13.0, 19.0];
array[P] of float: craft_min   = [20.0, 29.0];

% Available time (hours) converted to minutes
float: machine_avail_min = 40.0 * 60.0;
float: craft_avail_min   = 35.0 * 60.0;

% Costs (£/hour) converted to £/minute
float: machine_cost_per_min = 10.0 / 60.0;
float: craft_cost_per_min   =  2.0 / 60.0;

% Revenues (£/batch)
array[P] of float: revenue = [20.0, 30.0];

% Contract minimum for product X (batches)
float: min_X = 10.0;

%-----------------------------
% Decision variables
%-----------------------------
array[P] of var float: batches; % fractional batches allowed
constraint forall(p in P) (batches[p] >= 0.0);

%-----------------------------
% Resource constraints
%-----------------------------
constraint sum(p in P) (machine_min[p] * batches[p]) <= machine_avail_min;
constraint sum(p in P) (craft_min[p]   * batches[p]) <= craft_avail_min;

% Contract requirement
constraint batches[X] >= min_X;

%-----------------------------
% Objective: maximize profit
% Profit = Revenue - (machine cost used) - (craft cost used)
% Idle time has no cost (so only used time is charged).
%-----------------------------
var float: total_revenue =
  sum(p in P) (revenue[p] * batches[p]);

var float: total_machine_cost =
  machine_cost_per_min * sum(p in P) (machine_min[p] * batches[p]);

var float: total_craft_cost =
  craft_cost_per_min * sum(p in P) (craft_min[p] * batches[p]);

var float: profit = total_revenue - total_machine_cost - total_craft_cost;

solve maximize profit;

%-----------------------------
% Output
%-----------------------------
output [
  "Batches X = ", show(batches[X]), "\n",
  "Batches Y = ", show(batches[Y]), "\n",
  "Total revenue = ", show(total_revenue), "\n",
  "Machine cost = ", show(total_machine_cost), "\n",
  "Craft cost = ", show(total_craft_cost), "\n",
  "Profit = ", show(profit), "\n"
];