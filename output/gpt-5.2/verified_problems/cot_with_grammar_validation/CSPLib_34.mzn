% Parameters
int: n_suppliers;
int: n_stores;

int: building_cost;
array[1..n_suppliers] of int: capacity;
array[1..n_stores, 1..n_suppliers] of int: cost_matrix;

% Variables
array[1..n_suppliers] of var bool: open;
array[1..n_stores, 1..n_suppliers] of var bool: assign;

% Constraints
constraint
  forall(s in 1..n_stores)(
    sum(w in 1..n_suppliers)(bool2int(assign[s,w])) = 1
  );

constraint
  forall(s in 1..n_stores, w in 1..n_suppliers)(
    bool2int(assign[s,w]) <= bool2int(open[w])
  );

constraint
  forall(w in 1..n_suppliers)(
    sum(s in 1..n_stores)(bool2int(assign[s,w])) <= capacity[w]
  );

% Objective
solve minimize
  sum(w in 1..n_suppliers)(building_cost * bool2int(open[w])) +
  sum(s in 1..n_stores, w in 1..n_suppliers)(cost_matrix[s,w] * bool2int(assign[s,w]));