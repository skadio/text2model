int: demand = 2000;

set of int: DEV = 1..4;
array[DEV] of string: name = ["A","B","C","D"];

array[DEV] of int: prep_cost = [1000, 920, 800, 700];         % Yuan if device enabled
array[DEV] of int: unit_cost = [20, 24, 16, 28];              % Yuan per unit
array[DEV] of int: cap = [900, 1000, 1200, 1600];             % max units

array[DEV] of var 0..cap[DEV]: x;                             % units produced on each device
array[DEV] of var bool: use;                                  % whether device is enabled

constraint sum(d in DEV)(x[d]) = demand;

% If a device is not enabled, it cannot produce; if it produces, it must be enabled
constraint forall(d in DEV)(
  x[d] <= cap[d] * bool2int(use[d])
);

var int: total_cost = sum(d in DEV)(
  prep_cost[d] * bool2int(use[d]) + unit_cost[d] * x[d]
);

solve minimize total_cost;

output [
  "Total cost (Yuan) = ", show(total_cost), "\n",
  "Production plan:\n"
] ++
[ name[d] ++ ": use=" ++ show(use[d]) ++ ", x=" ++ show(x[d]) ++ "\n" | d in DEV ];