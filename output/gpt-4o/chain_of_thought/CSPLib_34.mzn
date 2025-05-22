% Parameters
int: n_suppliers;
int: n_stores;
int: building_cost;
array[1..n_suppliers] of int: capacity;
array[1..n_stores, 1..n_suppliers] of int: cost_matrix;

% Variables
array[1..n_suppliers] of var 0..1: open;                 % 1 if warehouse is opened
array[1..n_stores, 1..n_suppliers] of var 0..1: assign;  % 1 if store is supplied by warehouse

% Constraints
constraint forall(s in 1..n_stores)(
    sum(w in 1..n_suppliers)(assign[s,w]) = 1
);

constraint forall(s in 1..n_stores, w in 1..n_suppliers)(
    assign[s,w] <= open[w]
);

constraint forall(w in 1..n_suppliers)(
    sum(s in 1..n_stores)(assign[s,w]) <= capacity[w]
);

% Objective
var int: total_cost =
    sum(w in 1..n_suppliers)(building_cost * open[w]) +
    sum(s in 1..n_stores, w in 1..n_suppliers)(cost_matrix[s,w] * assign[s,w]);

solve minimize total_cost;