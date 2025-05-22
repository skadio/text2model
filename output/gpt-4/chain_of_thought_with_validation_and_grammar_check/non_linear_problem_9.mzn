% Parameters
int: P; % Number of warehouses to open
int: num_customers; % Number of customers
int: num_warehouses; % Number of warehouses
array[1..num_customers] of float: Demand; % Demand of each customer
array[1..num_customers, 1..num_warehouses] of float: Distance; % Distance between each customer and warehouse

% Variables
array[1..num_warehouses] of var 0..1: warehouse_open; % Whether each warehouse is open or not
array[1..num_customers, 1..num_warehouses] of var 0..1: customer_served; % Whether each customer is served by each warehouse

% Constraints
% Each customer is served by exactly one warehouse
constraint forall(i in 1..num_customers)(sum(j in 1..num_warehouses)(customer_served[i,j]) = 1);

% If a warehouse is not open, it cannot serve any customers
constraint forall(j in 1..num_warehouses)(sum(i in 1..num_customers)(customer_served[i,j]) <= warehouse_open[j]*num_customers);

% The number of open warehouses should be equal to P
constraint sum(j in 1..num_warehouses)(warehouse_open[j]) = P;

% Objective
% Minimize the sum of demand weighted distances of the customers to the warehouse that serves them
var float: total_distance = sum(i in 1..num_customers, j in 1..num_warehouses)(Demand[i]*Distance[i,j]*customer_served[i,j]);
solve minimize total_distance;