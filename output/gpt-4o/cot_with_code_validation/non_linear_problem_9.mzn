% Parameters
int: P;
int: num_customers;
int: num_warehouses;

set of int: Customers  = 1..num_customers;
set of int: Warehouses = 1..num_warehouses;

array[Customers]  of float: Demand;
array[Customers, Warehouses] of float: Distance;

% Variables
array[Warehouses] of var 0..1: open;                  % 1 if warehouse j is opened
array[Customers, Warehouses] of var 0..1: assign;     % 1 if customer i served by warehouse j

% Constraints
constraint                                    % open exactly P warehouses
    sum (j in Warehouses)(open[j]) = P;

constraint                                    % each customer assigned to one warehouse
    forall (i in Customers) (
        sum (j in Warehouses)(assign[i,j]) = 1
    );

constraint                                    % assignment only to opened warehouses
    forall (i in Customers, j in Warehouses) (
        assign[i,j] <= open[j]
    );

% Objective
var float: total_cost =
    sum (i in Customers, j in Warehouses)(
        Demand[i] * Distance[i,j] * assign[i,j]
    );

solve minimize total_cost;