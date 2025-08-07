include "globals.mzn";

int: P;                          % Number of warehouses to open
int: num_customers;              % Number of customers
int: num_warehouses;             % Number of warehouses
array[1..num_customers] of float: Demand;  % Demand of each customer
array[1..num_customers, 1..num_warehouses] of float: Distance;  % Distance between customers and warehouses

% Decision variables
array[1..num_warehouses] of var 0..1: open;  % 1 if warehouse is open, 0 otherwise
array[1..num_customers] of var 1..num_warehouses: assigned;  % Assigned warehouse for each customer

% Objective: Minimize the total demand-weighted distance
var float: total_cost = sum(i in 1..num_customers)(Demand[i] * Distance[i, assigned[i]]);

% Constraints
constraint sum(j in 1..num_warehouses)(open[j]) = P;  % Exactly P warehouses must be opened

% Each customer must be assigned to an open warehouse
constraint forall(i in 1..num_customers)(
    assigned[i] = j -> open[j] = 1
);

% Solve the model
solve minimize total_cost;

% Output the results
output [
    "Total Cost = ", show(total_cost), "\n",
    "Warehouses Open = ", show([j | j in 1..num_warehouses where open[j] == 1]), "\n",
    "Customer Assignments = ", show(assigned), "\n"
];