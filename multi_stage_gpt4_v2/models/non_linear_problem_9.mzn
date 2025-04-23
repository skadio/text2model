% Parameters
int: P; % Number of warehouses to open
int: num_customers; % Number of customers
int: num_warehouses; % Number of warehouses
array[1..num_customers] of int: Demand; % Demand of each customer
array[1..num_customers, 1..num_warehouses] of int: Distance; % Distance between each customer and warehouse

% Variables
array[1..num_warehouses] of var 0..1: open_warehouses; % Binary variable indicating whether a warehouse is open or not
array[1..num_customers, 1..num_warehouses] of var 0..1: serve; % Binary variable indicating whether a warehouse serves a customer or not

% Constraints

% Each customer is served by exactly one warehouse
constraint forall(i in 1..num_customers) (
  sum(j in 1..num_warehouses) (serve[i,j]) = 1
);

% If a warehouse is not open, it cannot serve any customer
constraint forall(j in 1..num_warehouses) (
  forall(i in 1..num_customers) (
    serve[i,j] <= open_warehouses[j]
  )
);

% The number of open warehouses should be equal to P
constraint sum(j in 1..num_warehouses) (open_warehouses[j]) = P;

% Objective
solve minimize sum(i in 1..num_customers, j in 1..num_warehouses) (Demand[i] * Distance[i,j] * serve[i,j]);