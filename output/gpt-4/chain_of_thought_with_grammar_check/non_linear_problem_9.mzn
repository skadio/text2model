% Parameters
int: P;
int: num_customers;
int: num_warehouses;
array[1..num_customers] of float: Demand;
array[1..num_customers, 1..num_warehouses] of float: Distance;

% Variables
array[1..num_customers, 1..num_warehouses] of var 0..1: x; % x[i,j] = 1 if customer i is served by warehouse j
array[1..num_warehouses] of var 0..1: y; % y[j] = 1 if warehouse j is open

% Constraints
constraint forall(i in 1..num_customers)(sum(j in 1..num_warehouses)(x[i,j]) = 1); % Each customer is served by exactly one warehouse
constraint forall(i in 1..num_customers, j in 1..num_warehouses)(x[i,j] <= y[j]); % A customer can only be served by an open warehouse
constraint sum(j in 1..num_warehouses)(y[j]) = P; % Exactly P warehouses are open

% Objective
var float: total_distance;
constraint total_distance = sum(i in 1..num_customers, j in 1..num_warehouses)(Demand[i]*Distance[i,j]*x[i,j]);
solve minimize total_distance;