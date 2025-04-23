% Input parameters
int: P; % Number of warehouses to open
int: num_customers; % Number of customers
int: num_warehouses; % Number of warehouses
array[1..num_customers] of float: Demand; % Demand of each customer
array[1..num_customers, 1..num_warehouses] of float: Distance; % Distance between each customer and warehouse

% Decision variables
array[1..num_warehouses] of var 0..1: open; % Whether each warehouse is open
array[1..num_customers, 1..num_warehouses] of var 0..1: serve; % Whether each warehouse serves each customer

% Objective function
var float: total_distance = sum(i in 1..num_customers, j in 1..num_warehouses) (Demand[i] * Distance[i,j] * serve[i,j]);
minimize total_distance;

% Constraints
constraint sum(i in 1..num_warehouses) (open[i]) = P; % Exactly P warehouses must be open
constraint forall(i in 1..num_customers) (sum(j in 1..num_warehouses) (serve[i,j]) = 1); % Each customer is served by exactly one warehouse
constraint forall(i in 1..num_customers, j in 1..num_warehouses) (serve[i,j] <= open[j]); % A warehouse can only serve a customer if it is open

% Solve and output
solve satisfy;
output ["Total distance: ", show(total_distance), "\n"];
output ["Open warehouses: ", show(open), "\n"];
output ["Serving matrix: ", show(serve), "\n"];