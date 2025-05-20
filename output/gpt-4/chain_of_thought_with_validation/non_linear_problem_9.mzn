% Parameters
int: P;
int: num_customers;
int: num_warehouses;
array[1..num_customers] of float: Demand;
array[1..num_customers, 1..num_warehouses] of float: Distance;

% Variables
array[1..num_customers, 1..num_warehouses] of var 0..1: Serve;
array[1..num_warehouses] of var 0..1: Open;

% Constraints
constraint forall(i in 1..num_customers)(sum(j in 1..num_warehouses)(Serve[i,j]) = 1);
constraint forall(j in 1..num_warehouses)(sum(i in 1..num_customers)(Serve[i,j]) <= num_customers * Open[j]);
constraint sum(j in 1..num_warehouses)(Open[j]) = P;

% Objective
var float: total_distance;
constraint total_distance = sum(i in 1..num_customers, j in 1..num_warehouses)(Serve[i,j] * Distance[i,j] * Demand[i]);
solve minimize total_distance;