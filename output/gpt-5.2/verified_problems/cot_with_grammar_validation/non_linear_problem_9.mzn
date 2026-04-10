% Parameters
int: P;
int: num_customers;
int: num_warehouses;

set of int: Customers = 1..num_customers;
set of int: Warehouses = 1..num_warehouses;

array[Customers] of float: Demand;
array[Customers, Warehouses] of float: Distance;

% Variables
array[Warehouses] of var bool: open;
array[Customers, Warehouses] of var bool: assign;

% Constraints
constraint sum(w in Warehouses)(bool2int(open[w])) = P;

constraint
  forall(c in Customers)(
    sum(w in Warehouses)(bool2int(assign[c,w])) = 1
  );

constraint
  forall(c in Customers, w in Warehouses)(
    assign[c,w] -> open[w]
  );

% Objective
solve minimize
  sum(c in Customers, w in Warehouses)(
    Demand[c] * Distance[c,w] * bool2int(assign[c,w])
  );