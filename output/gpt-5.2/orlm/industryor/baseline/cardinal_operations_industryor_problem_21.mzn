% Production planning with fixed activation costs and minimum batch sizes
% Units:
% - Decision variables x[p] are in "100 kg" units produced over the month.
% - Demand and quota are in the same "100 kg" units.
% - Prices and variable costs are in $ per 100 kg.
% - Activation costs are in $ (fixed if product is produced at all).

int: days = 22;

set of int: P = 1..3;
array[P] of string: pname = ["A1","A2","A3"];

array[P] of int: max_demand = [5300, 4500, 5400];     % max monthly demand (100kg units)
array[P] of int: quota_per_day = [500, 450, 550];     % max units per day if fully devoted
array[P] of int: min_batch = [20, 20, 16];            % minimum production if activated (100kg units)

array[P] of float: price = [124.0, 109.0, 115.0];     % $ per 100kg
array[P] of float: var_cost = [73.30, 52.90, 65.40];  % $ per 100kg
array[P] of float: act_cost = [170000.0, 150000.0, 100000.0]; % $

% Maximum possible production in the month if all days devoted to product p
array[P] of int: cap_month = [days * quota_per_day[p] | p in P];

array[P] of var int: x;      % monthly production (100kg units)
array[P] of var bool: y;     % 1 if product is activated/produced, else 0

constraint
  forall(p in P) (
    x[p] >= 0 /\
    x[p] <= max_demand[p] /\
    x[p] <= cap_month[p] /\
    x[p] <= cap_month[p] * bool2int(y[p]) /\
    x[p] >= min_batch[p] * bool2int(y[p])
  );

var float: profit =
  sum(p in P) ( (price[p] - var_cost[p]) * int2float(x[p]) - act_cost[p] * bool2int(y[p]) );

solve maximize profit;

output [
  "Objective (profit) = ", show(profit), "\n",
  "Days available = ", show(days), "\n\n"
] ++
[
  "Product ", pname[p], ": x=", show(x[p]), " (100kg units), activated=", show(y[p]), "\n"
  | p in P
];