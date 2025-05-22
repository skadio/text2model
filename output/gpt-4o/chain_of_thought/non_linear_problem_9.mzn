% Parameters
int: P;                                   % Number of warehouses to open
int: num_customers;                       % Number of customers
int: num_warehouses;                      % Number of candidate warehouse locations

set of int: Customers   = 1..num_customers;
set of int: Warehouses  = 1..num_warehouses;

array[Customers]                of float: Demand;      % Demand of each customer
array[Customers, Warehouses]    of float: Distance;    % Distance matrix (customer, warehouse)

% Variables
array[Warehouses]                 of var 0..1: open;       % 1 if warehouse j is opened
array[Customers, Warehouses]      of var 0..1: assign;     % 1 if customer i served by warehouse j

% Constraints
% 1. Exactly P warehouses must be opened
constraint
    sum(j in Warehouses) (open[j]) = P;

% 2. Each customer is assigned to exactly one warehouse
constraint
    forall(i in Customers) (
        sum(j in Warehouses) (assign[i,j]) = 1
    );

% 3. Customers can only be assigned to opened warehouses
constraint
    forall(i in Customers, j in Warehouses) (
        assign[i,j] <= open[j]
    );

% Objective
var float: total_cost = 
    sum(i in Customers, j in Warehouses) (
        Demand[i] * Distance[i,j] * int2float(assign[i,j])
    );

solve minimize total_cost;