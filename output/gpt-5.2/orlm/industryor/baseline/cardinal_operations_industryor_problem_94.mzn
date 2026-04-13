% Beverage production planning over 4 weeks with inventory holding cost
% Units:
% - Demand, production, inventory: 1000 boxes
% - Costs: 1000 yuan

int: T = 4;
set of int: W = 1..T;

array[W] of int: demand = [15, 25, 35, 25];
array[W] of int: cap    = [30, 40, 45, 20];

% Production cost per 1000 boxes (in 1000 yuan)
array[W] of float: prod_cost = [5.0, 5.1, 5.4, 5.5];

% Inventory holding cost per 1000 boxes per week (in 1000 yuan)
float: hold_cost = 0.2;

% Decision variables
array[W] of var 0..max(cap): prod;                 % production each week
array[0..T] of var 0..sum(cap): inv;               % end-of-week inventory
constraint inv[0] = 0;

% Inventory balance and demand satisfaction
constraint forall(w in W) (
  inv[w] = inv[w-1] + prod[w] - demand[w]
);

% No backlogging allowed
constraint forall(w in W) (inv[w] >= 0);

% Capacity constraints
constraint forall(w in W) (prod[w] <= cap[w]);

% Objective: production cost + holding cost (holding charged on end-of-week inventory)
var float: total_cost =
  sum(w in W) (prod_cost[w] * int2float(prod[w])) +
  sum(w in W) (hold_cost * int2float(inv[w]));

solve minimize total_cost;

output [
  "Production plan (1000 boxes):\n",
  concat([ "Week " ++ show(w) ++ ": prod=" ++ show(prod[w]) ++
           ", end_inv=" ++ show(inv[w]) ++ "\n"
         | w in W ]),
  "Total cost (1000 yuan) = ", show(total_cost), "\n"
];