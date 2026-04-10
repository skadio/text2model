% Contract reservation production planning with inventory + backlog
% Data embedded (no .dzn required)

include "globals.mzn";

int: P = 3;
int: Q = 4;

set of int: Products = 1..P;
set of int: Quarters = 1..Q;

% Demand[product, quarter]
array[Products, Quarters] of int: demand =
  array2d(Products, Quarters,
  [
    1500, 1000, 2000, 1200,   % Product I
    1500, 1500, 1200, 1500,   % Product II
    1000, 2000, 1500, 2500    % Product III
  ]);

array[Products] of int: hours_per_unit = [2, 4, 3];
int: hours_capacity_per_quarter = 15000;

array[Products] of int: init_inventory = [0, 0, 0];
array[Products] of int: end_inventory_req = [150, 150, 150];

int: holding_cost = 5;
array[Products] of int: delay_cost = [20, 20, 10];

% Safe upper bounds (tight and small to avoid timeouts)
array[Products] of int: total_demand = [sum(q in Quarters)(demand[p,q]) | p in Products];
array[Products] of int: max_stock = [total_demand[p] + end_inventory_req[p] | p in Products];
int: max_any = max(p in Products)(max_stock[p]);

% Decision variables
% prod[p,q] = production in quarter q
array[Products, Quarters] of var 0..max_any: prod;

% ship[p,q] = delivered in quarter q
array[Products, Quarters] of var 0..max_any: ship;

% inv[p,q] = inventory at end of quarter q
array[Products, Quarters] of var 0..max_any: inv;

% back[p,q] = backlog at end of quarter q
array[Products, Quarters] of var 0..max_any: back;

% Capacity per quarter
constraint forall(q in Quarters)(
  sum(p in Products)(hours_per_unit[p] * prod[p,q]) <= hours_capacity_per_quarter
);

% Product I cannot be produced in quarter 2
constraint prod[1,2] = 0;

% Flow constraints using separate inventory/backlog evolution
% Inventory:
% inv[p,q] = inv[p,q-1] + prod[p,q] - shipped_from_inventory[p,q]
% Backlog:
% back[p,q] = back[p,q-1] + demand[p,q] - shipped_to_backlog[p,q]
% And total ship is split: ship = shipped_from_inventory + shipped_to_backlog
array[Products, Quarters] of var 0..max_any: ship_from_inv;
array[Products, Quarters] of var 0..max_any: ship_from_back;

constraint forall(p in Products, q in Quarters)(
  ship[p,q] = ship_from_inv[p,q] + ship_from_back[p,q]
);

% Quarter 1 base
constraint forall(p in Products)(
  inv[p,1] = init_inventory[p] + prod[p,1] - ship_from_inv[p,1]
);
constraint forall(p in Products)(
  back[p,1] = demand[p,1] - ship_from_back[p,1]
);

% Quarters 2..Q
constraint forall(p in Products, q in 2..Q)(
  inv[p,q] = inv[p,q-1] + prod[p,q] - ship_from_inv[p,q]
);
constraint forall(p in Products, q in 2..Q)(
  back[p,q] = back[p,q-1] + demand[p,q] - ship_from_back[p,q]
);

% Shipping limited by availability
constraint forall(p in Products, q in Quarters)(
  ship_from_inv[p,q] <= (if q=1 then init_inventory[p] else inv[p,q-1] endif) + prod[p,q]
);
constraint forall(p in Products, q in Quarters)(
  ship_from_back[p,q] <= (if q=1 then 0 else back[p,q-1] endif) + demand[p,q]
);

% End-of-horizon requirements
constraint forall(p in Products)(back[p,Q] = 0);
constraint forall(p in Products)(inv[p,Q] = end_inventory_req[p]);

% Objective: holding cost on end-of-quarter inventory; delay cost on end-of-quarter backlog
var int: total_cost =
  holding_cost * sum(p in Products, q in Quarters)(inv[p,q])
  + sum(p in Products, q in Quarters)(delay_cost[p] * back[p,q]);

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "Production (p x q):\n",
  concat([concat([show(prod[p,q]) ++ if q<Q then "\t" else "\n" endif | q in Quarters]) | p in Products]),
  "Shipments (p x q):\n",
  concat([concat([show(ship[p,q]) ++ if q<Q then "\t" else "\n" endif | q in Quarters]) | p in Products]),
  "Inventory end (p x q):\n",
  concat([concat([show(inv[p,q]) ++ if q<Q then "\t" else "\n" endif | q in Quarters]) | p in Products]),
  "Backlog end (p x q):\n",
  concat([concat([show(back[p,q]) ++ if q<Q then "\t" else "\n" endif | q in Quarters]) | p in Products])
];