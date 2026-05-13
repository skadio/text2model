% Parameters
int: P;
int: num_customers;
int: num_warehouses;
array[1..num_customers] of float: Demand;
array[1..num_customers, 1..num_warehouses] of float: Distance;

% Variables
array[1..num_warehouses] of var 0..1: open;
array[1..num_customers] of var 1..num_warehouses: assign;

% Constraints
constraint sum(open) = P;
constraint forall(i in 1..num_customers)(open[assign[i]] = 1);

% Objective
solve minimize sum(i in 1..num_customers)(Demand[i] * Distance[i, assign[i]]);