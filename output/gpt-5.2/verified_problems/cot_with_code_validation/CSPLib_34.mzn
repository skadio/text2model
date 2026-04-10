% Warehouse Location Problem (WLP)

% Parameters
int: n_suppliers;
int: n_stores;
int: building_cost;

array[1..n_suppliers] of int: capacity;
array[1..n_stores, 1..n_suppliers] of int: cost_matrix;

% Decision variables
array[1..n_suppliers] of var bool: open;
array[1..n_stores, 1..n_suppliers] of var bool: assign;

% Each store is supplied by exactly one warehouse
constraint
  forall(s in 1..n_stores) (
    sum(w in 1..n_suppliers)(bool2int(assign[s,w])) = 1
  );

% Stores can only be assigned to open warehouses
constraint
  forall(s in 1..n_stores, w in 1..n_suppliers) (
    assign[s,w] -> open[w]
  );

% Capacity constraints
constraint
  forall(w in 1..n_suppliers) (
    sum(s in 1..n_stores)(bool2int(assign[s,w])) <= capacity[w]
  );

% Objective
var int: total_cost =
  building_cost * sum(w in 1..n_suppliers)(bool2int(open[w])) +
  sum(s in 1..n_stores, w in 1..n_suppliers)(cost_matrix[s,w] * bool2int(assign[s,w]));

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "open=", show([bool2int(open[w]) | w in 1..n_suppliers]), "\n"
];