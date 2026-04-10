include "globals.mzn";

% Data
int: P;
int: num_customers;
int: num_warehouses;
array[1..num_customers] of float: Demand;
array[1..num_customers, 1..num_warehouses] of float: Distance;

% Decision variables
% open[j] = 1 if warehouse j is opened, 0 otherwise.
array[1..num_warehouses] of var 0..1: open;
% For each customer i, serve[i] is the index of the warehouse serving that customer.
array[1..num_customers] of var 1..num_warehouses: serve;

% Exactly P warehouses must be open.
constraint count(open, 1, P);

% A customer can only be served by an open warehouse.
constraint forall(i in 1..num_customers)( open[serve[i]] = 1 );

% Objective: minimize total demand-weighted distance.
var float: totalCost = sum(i in 1..num_customers)( Demand[i] * Distance[i, serve[i]] );

solve minimize totalCost;

output [
  "Total cost: ", show(totalCost), "\n",
  "Open warehouses: ", show(open), "\n",
  "Customer assignments (warehouse indices): ", show(serve), "\n"
];