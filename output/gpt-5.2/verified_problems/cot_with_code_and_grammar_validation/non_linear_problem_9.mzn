% Parameters
int: P;
int: num_customers;
int: num_warehouses;

set of int: Customers = 1..num_customers;
set of int: Warehouses = 1..num_warehouses;

array[Customers] of float: Demand;
array[Customers, Warehouses] of float: Distance;

% Variables
array[Warehouses] of var 0..1: open;
array[Customers, Warehouses] of var 0..1: assign;

var float: total_cost;

% Constraints
constraint P >= 0 /\ P <= num_warehouses;

constraint sum(w in Warehouses)(open[w]) = P;

constraint
  forall(c in Customers)(
    sum(w in Warehouses)(assign[c,w]) = 1
  );

constraint
  forall(c in Customers, w in Warehouses)(
    assign[c,w] <= open[w]
  );

% Objective
constraint
  total_cost = sum(c in Customers, w in Warehouses)(
    Demand[c] * Distance[c,w] * assign[c,w]
  );

solve minimize total_cost;