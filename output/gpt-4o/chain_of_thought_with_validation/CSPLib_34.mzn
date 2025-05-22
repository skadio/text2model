% Parameters
int: n_suppliers;
int: n_stores;
int: building_cost;
array[1..n_suppliers] of int: capacity;
array[1..n_stores, 1..n_suppliers] of int: cost_matrix;

set of int: SUPPLIERS = 1..n_suppliers;
set of int: STORES    = 1..n_stores;

% Variables
array[SUPPLIERS] of var 0..1: y;                         % 1 if warehouse i is opened
array[STORES, SUPPLIERS] of var 0..1: x;                 % 1 if store s served by warehouse i

% Constraints
constraint
    forall(s in STORES) (
        sum(i in SUPPLIERS)(x[s,i]) == 1                 % each store assigned exactly one warehouse
    );

constraint
    forall(i in SUPPLIERS) (
        sum(s in STORES)(x[s,i]) <= capacity[i]          % respect warehouse capacity
    );

constraint
    forall(s in STORES, i in SUPPLIERS) (
        x[s,i] <= y[i]                                   % cannot assign to a closed warehouse
    );

% Objective
var int: total_cost =
    sum(i in SUPPLIERS)(building_cost * y[i]) +
    sum(s in STORES, i in SUPPLIERS)(cost_matrix[s,i] * x[s,i]);

solve minimize total_cost;