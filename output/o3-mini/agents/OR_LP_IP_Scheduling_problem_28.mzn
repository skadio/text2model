include "globals.mzn";

% Data from the .dzn file:
int: num_parts;
int: num_stores;
array[1..num_parts, 1..num_stores] of float: product_stores;
array[1..num_stores] of float: store_delivery_costs;

% Decision variables:
% partStore[i] is the store chosen for part i.
array[1..num_parts] of var 1..num_stores: partStore;
% countStore[s] is the number of parts purchased from store s.
array[1..num_stores] of var 0..num_parts: countStore;

% Linking the assignment with the counts  
constraint 
  forall(s in 1..num_stores)(
    count(partStore, s, countStore[s])
  );

% Objective cost:
% The total cost is the sum of product costs (price depends on chosen store)
% plus delivery cost for each store that has at least one product assigned.
var float: totalCost = sum(i in 1..num_parts)( product_stores[i, partStore[i]] )
                      + sum(s in 1..num_stores)( if countStore[s] > 0 then store_delivery_costs[s] else 0.0 );

solve minimize totalCost;

output [
  "Part assignments (store index per part): ", show(partStore), "\n",
  "Total Cost: ", show(totalCost), "\n"
];