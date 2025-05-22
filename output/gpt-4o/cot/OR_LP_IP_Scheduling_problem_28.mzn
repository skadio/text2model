% Parameters
int: num_parts;
int: num_stores;

array[1..num_parts, 1..num_stores] of float: product_stores;
array[1..num_stores] of float: store_delivery_costs;

% Variables
array[1..num_parts, 1..num_stores] of var 0..1: x;      % 1 if part p bought at store s
array[1..num_stores]                of var 0..1: y;      % 1 if at least one part bought from store s
var float: total_cost;                                   % total purchasing + delivery cost

% Constraints
% Each part is bought exactly once
constraint
    forall(p in 1..num_parts)(
        sum(s in 1..num_stores)(x[p,s]) = 1
    );

% Activate a store iff at least one part is bought there
constraint
    forall(s in 1..num_stores)(
        sum(p in 1..num_parts)(x[p,s]) <= num_parts * y[s]
    );

constraint
    forall(s in 1..num_stores)(
        y[s] <= sum(p in 1..num_parts)(x[p,s])
    );

% Total cost calculation
constraint
    total_cost = 
        sum(p in 1..num_parts, s in 1..num_stores)(
            int2float(x[p,s]) * product_stores[p,s]
        )
      + sum(s in 1..num_stores)(
            int2float(y[s]) * store_delivery_costs[s]
        );

% Objective
solve minimize total_cost;