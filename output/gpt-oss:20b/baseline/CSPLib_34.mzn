int: n_suppliers;
int: n_stores;
int: building_cost;
array[1..n_suppliers] of int: capacity;
array[1..n_stores, 1..n_suppliers] of int: cost_matrix;

array[1..n_suppliers] of var bool: open;
array[1..n_stores, 1..n_suppliers] of var bool: assign;

constraint
  forall(s in 1..n_stores) (
    sum(i in 1..n_suppliers) assign[s][i] = 1
  );

constraint
  forall(i in 1..n_suppliers) (
    sum(s in 1..n_stores) assign[s][i] <= capacity[i] * open[i]
  );

constraint
  forall(s in 1..n_stores, i in 1..n_suppliers) (
    assign[s][i] <= open[i]
  );

solve minimize
  sum(i in 1..n_suppliers) building_cost * open[i] +
  sum(s in 1..n_stores, i in 1..n_suppliers) cost_matrix[s][i] * assign[s][i];

output [
  "Open warehouses: ", show([i | i in 1..n_suppliers where open[i]]), "\n",
  "Assignments:\n",
  concat([ "Store " ++ show(s) ++ " -> Warehouse " ++ show(i) ++ "\n" |
          s in 1..n_stores,
          i in 1..n_suppliers where assign[s][i] ])
];