int: P;
int: num_customers;
int: num_warehouses;

set of int: Customers = 1..num_customers;
set of int: Warehouses = 1..num_warehouses;

array[Customers] of float: Demand;
array[Customers, Warehouses] of float: Distance;

array[Warehouses] of var bool: open;
array[Customers, Warehouses] of var bool: assign;

constraint sum(w in Warehouses)(bool2int(open[w])) = P;

constraint
  forall(c in Customers)(
    sum(w in Warehouses)(bool2int(assign[c,w])) = 1
  );

constraint
  forall(c in Customers, w in Warehouses)(
    assign[c,w] -> open[w]
  );

var float: total_cost =
  sum(c in Customers, w in Warehouses)(
    Demand[c] * Distance[c,w] * bool2float(assign[c,w])
  );

solve minimize total_cost;

output [
  "total_cost=", show(total_cost), "\n",
  "open=", show([ bool2int(open[w]) | w in Warehouses ]), "\n",
  "assign=\n"
] ++
[
  concat([ show(bool2int(assign[c,w])) ++ (if w == num_warehouses then "\n" else " " endif)
        | w in Warehouses ])
  | c in Customers
];