include "globals.mzn";

% ---------- Input ----------
int: num_parts;
int: num_stores;

array[1..num_parts, 1..num_stores] of float: product_stores;     % price of part p in store s
array[1..num_stores] of float: store_delivery_costs;             % delivery cost for store s

% ---------- Decision variables ----------
array[1..num_parts] of var 1..num_stores: store_of_part;         % which store to buy each part from
array[1..num_stores] of var bool: used_store;                    % whether we buy at least one part from store s

% ---------- Linking constraints ----------
constraint
  forall(s in 1..num_stores) (
    used_store[s] <-> exists(p in 1..num_parts)(store_of_part[p] = s)
  );

% ---------- Objective ----------
var float: total_product_cost =
  sum(p in 1..num_parts)(
    product_stores[p, store_of_part[p]]
  );

var float: total_delivery_cost =
  sum(s in 1..num_stores)(
    store_delivery_costs[s] * bool2int(used_store[s])
  );

var float: total_cost = total_product_cost + total_delivery_cost;

solve minimize total_cost;

% ---------- Output ----------
output [
  "store_of_part = ", show(store_of_part), "\n",
  "used_store    = ", show(used_store), "\n",
  "product_cost  = ", show(total_product_cost), "\n",
  "delivery_cost = ", show(total_delivery_cost), "\n",
  "total_cost    = ", show(total_cost), "\n"
];