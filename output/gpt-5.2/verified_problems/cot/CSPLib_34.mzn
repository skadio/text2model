% Parameters
int: n_suppliers;
int: n_stores;

int: building_cost;
array[1..n_suppliers] of int: capacity;
array[1..n_stores, 1..n_suppliers] of int: cost_matrix;

set of int: SUPPLIERS = 1..n_suppliers;
set of int: STORES = 1..n_stores;

% Variables
array[SUPPLIERS] of var 0..1: open;
array[STORES, SUPPLIERS] of var 0..1: assign;

% Constraints
constraint
  forall(s in STORES) (
    sum(w in SUPPLIERS)(assign[s,w]) = 1
  );

constraint
  forall(w in SUPPLIERS) (
    sum(s in STORES)(assign[s,w]) <= capacity[w]
  );

constraint
  forall(s in STORES, w in SUPPLIERS) (
    assign[s,w] <= open[w]
  );

% Objective
solve minimize
  building_cost * sum(w in SUPPLIERS)(open[w]) +
  sum(s in STORES, w in SUPPLIERS)(cost_matrix[s,w] * assign[s,w]);