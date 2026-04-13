% Parameters
int: num_parts;                        % Number of different parts to buy
int: num_stores;                       % Number of stores available

set of int: PARTS = 1..num_parts;      % Index set of parts
set of int: STORES = 1..num_stores;    % Index set of stores

array[PARTS, STORES] of float: product_stores;     % Price of each part in each store
array[STORES] of float: store_delivery_costs;      % Delivery cost per store (paid once if store is used)

% Variables
array[PARTS] of var STORES: part_store;            % Assigned store for each part
array[STORES] of var bool: store_used;             % True iff at least one part is bought from that store

var float: total_product_cost;                     % Sum of selected part prices
var float: total_delivery_cost;                    % Sum of delivery costs for used stores
var float: total_cost;                             % Total objective cost (products + delivery)

% Constraints

% Link store_used[s] with whether any part is assigned to store s
constraint
  forall(s in STORES) (
    store_used[s] <-> exists(p in PARTS) (part_store[p] = s)
  );

% Compute total cost of selected products (sum of prices for chosen store per part)
constraint
  total_product_cost =
    sum(p in PARTS) ( product_stores[p, part_store[p]] );

% Compute total delivery cost (pay delivery once per used store)
constraint
  total_delivery_cost =
    sum(s in STORES) ( store_delivery_costs[s] * int2float(bool2int(store_used[s])) );

% Total cost decomposition (products + delivery)
constraint
  total_cost = total_product_cost + total_delivery_cost;

% Objective
solve minimize total_cost;