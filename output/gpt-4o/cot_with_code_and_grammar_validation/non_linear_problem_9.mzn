% Parameters
int: P;                                        % Number of warehouses to open
int: num_customers;                            % Number of customers
int: num_warehouses;                           % Number of candidate warehouse locations

set of int: Customers   = 1..num_customers;
set of int: Warehouses  = 1..num_warehouses;

array[Customers]              of float: Demand;                                  % Demand of each customer
array[Customers, Warehouses]  of float: Distance;                                % Distance matrix (customer, warehouse)

% Variables
array[Warehouses]                     of var 0..1: x;                            % 1 if warehouse w is opened
array[Customers, Warehouses]          of var 0..1: y;                            % 1 if customer c assigned to warehouse w

% Constraints
constraint
    sum(w in Warehouses)(x[w]) = P;                                               % Open exactly P warehouses

constraint
    forall(c in Customers)(
        sum(w in Warehouses)(y[c,w]) = 1                                          % Each customer served by exactly one warehouse
    );

constraint
    forall(c in Customers, w in Warehouses)(
        y[c,w] <= x[w]                                                           % Customers can only be assigned to opened warehouses
    );

% Objective
var float: total_cost = sum(c in Customers, w in Warehouses)(
                            Demand[c] * Distance[c,w] * y[c,w]);                 % Demand-weighted distance

solve minimize total_cost;