% Parameters
int: n_suppliers;
int: n_stores;
int: building_cost;
array[1..n_suppliers] of int: capacity;
array[1..n_stores, 1..n_suppliers] of int: cost_matrix;

% Variables
array[1..n_suppliers] of var 0..1: open;
array[1..n_stores, 1..n_suppliers] of var 0..1: assignment;

% Constraints
constraint
  % Each store is supplied by exactly one warehouse
  forall(i in 1..n_stores) (
    sum(s in 1..n_suppliers) assignment[i,s] = 1
  )
  /\ % A store can only be assigned to an open warehouse
  forall(i in 1..n_stores, s in 1..n_suppliers) (
    assignment[i,s] <= open[s]
  )
  /\ % Capacity constraints for each warehouse
  forall(s in 1..n_suppliers) (
    sum(i in 1..n_stores) assignment[i,s] <= capacity[s]
  );

% Objective
solve minimize
  sum(s in 1..n_suppliers) building_cost * open[s]
  + sum(i in 1..n_stores, s in 1..n_suppliers) cost_matrix[i,s] * assignment[i,s];