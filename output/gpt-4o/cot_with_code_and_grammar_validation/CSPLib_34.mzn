% Parameters
int: n_suppliers;
int: n_stores;
int: building_cost;
array[1..n_suppliers] of int: capacity;
array[1..n_stores, 1..n_suppliers] of int: cost_matrix;

set of int: SUPPLIERS = 1..n_suppliers;
set of int: STORES     = 1..n_stores;

% Variables
array[SUPPLIERS] of var 0..1: open;                           % 1 if warehouse w is opened
array[STORES, SUPPLIERS] of var 0..1: supply;                 % 1 if store s is supplied by warehouse w

% Constraints
constraint
    forall(s in STORES)(
        sum(w in SUPPLIERS)(supply[s,w]) = 1                  % each store supplied by exactly one warehouse
    );

constraint
    forall(w in SUPPLIERS)(
        sum(s in STORES)(supply[s,w]) <= capacity[w] * open[w] % respect capacity and linking
    );

% Objective
var int: total_cost =                                         % total cost to minimise
        sum(w in SUPPLIERS)(building_cost * open[w]) +
        sum(s in STORES, w in SUPPLIERS)(cost_matrix[s,w] * supply[s,w]);

solve minimize total_cost;