int: n_suppliers;
int: n_stores;

int: building_cost;
array[1..n_suppliers] of int: capacity;
array[1..n_stores, 1..n_suppliers] of int: cost_matrix;

set of int: SUPPLIERS = 1..n_suppliers;
set of int: STORES = 1..n_stores;

array[SUPPLIERS] of var bool: open;
array[STORES] of var SUPPLIERS: assign;

constraint
  forall(s in STORES) (
    open[assign[s]]
  );

constraint
  forall(w in SUPPLIERS) (
    sum(s in STORES)(bool2int(assign[s] == w)) <= capacity[w]
  );

var int: total_cost =
  building_cost * sum(w in SUPPLIERS)(bool2int(open[w])) +
  sum(s in STORES)(cost_matrix[s, assign[s]]);

solve minimize total_cost;

output [
  "total_cost = ", show(total_cost), "\n",
  "open = ", show(open), "\n",
  "assign = ", show(assign), "\n"
];