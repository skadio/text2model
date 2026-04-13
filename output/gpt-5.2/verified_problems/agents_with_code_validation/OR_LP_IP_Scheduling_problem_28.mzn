% Parameters
int: num_parts;                         % Number of different parts to buy
int: num_stores;                        % Number of stores available

set of int: PARTS = 1..num_parts;       % Index set for parts
set of int: STORES = 1..num_stores;     % Index set for stores

array[PARTS, STORES] of float: product_stores;        % Price of each part in each store
array[STORES] of float: store_delivery_costs;         % Delivery cost per store (paid once if any part bought there)

% Variables
array[PARTS] of var STORES: store_of_part;            % Chosen store for each part
array[STORES] of var bool: store_used;                % True if at least one part is bought from the store

var float: total_product_cost;                        % Sum of selected part prices
var float: total_delivery_cost;                       % Sum of delivery costs for used stores
var float: total_cost;                                % Total cost = product + delivery

% Constraints

% Link store_used with whether any part is assigned to the store
constraint
  forall(s in STORES) (
    store_used[s] <-> exists(p in PARTS) (store_of_part[p] = s)
  );

% Compute total product cost as the sum of chosen prices for each part
constraint
  total_product_cost =
    sum(p in PARTS) ( product_stores[p, store_of_part[p]] );

% Compute total delivery cost: pay delivery once per used store
constraint
  total_delivery_cost =
    sum(s in STORES) ( store_delivery_costs[s] * bool2int(store_used[s]) );

% Total cost decomposition
constraint
  total_cost = total_product_cost + total_delivery_cost;

% Objective
solve minimize total_cost;