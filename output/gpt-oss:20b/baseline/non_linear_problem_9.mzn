int: P;
int: num_customers;
int: num_warehouses;
array[1..num_customers] of float: Demand;
array[1..num_customers, 1..num_warehouses] of float: Distance;

set of int: Customers = 1..num_customers;
set of int: Warehouses = 1..num_warehouses;

var bool: open[Warehouses];
var int: assignment[Customers] in Warehouses;

constraint sum(w in Warehouses)(bool2int(open[w])) = P;
constraint forall(c in Customers)(open[assignment[c]]);

var float: total_cost = sum(c in Customers)(Demand[c] * Distance[c, assignment[c]]);

solve minimize total_cost;

output [
  "Open warehouses: ", show([w | w in Warehouses where open[w]]), "\n",
  "Assignments: ", show([assignment[c] | c in Customers]), "\n",
  "Total cost: ", show(total_cost), "\n"
];