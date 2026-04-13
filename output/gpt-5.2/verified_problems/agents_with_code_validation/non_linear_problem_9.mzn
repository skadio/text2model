% Parameters
int: P;                              % Number of warehouses to open
int: num_customers;                  % Number of customers
int: num_warehouses;                 % Number of candidate warehouses

set of int: Customers = 1..num_customers;
set of int: Warehouses = 1..num_warehouses;

array[Customers] of float: Demand;                 % Demand of each customer
array[Customers, Warehouses] of float: Distance;   % Distance from customer to warehouse


% Variables
array[Warehouses] of var bool: open;               % open[w] = true if warehouse w is opened
array[Customers, Warehouses] of var bool: assign;  % assign[c,w] = true if customer c served by warehouse w

var float: total_cost;                             % Sum of demand-weighted service distances


% Constraints

%--- Warehouse opening cardinality: open exactly P warehouses
constraint
  sum(w in Warehouses)(bool2int(open[w])) = P;

%--- Customer assignment: each customer is assigned to exactly one warehouse
constraint
  forall(c in Customers)(
    sum(w in Warehouses)(bool2int(assign[c,w])) = 1
  );

%--- Linking: customers can only be assigned to warehouses that are open
constraint
  forall(c in Customers, w in Warehouses)(
    assign[c,w] -> open[w]
  );

%--- Total cost definition: demand-weighted distance for all customer assignments
constraint
  total_cost =
    sum(c in Customers, w in Warehouses)(
      (if assign[c,w] then 1.0 else 0.0 endif) * Demand[c] * Distance[c,w]
    );


% Objective
solve minimize total_cost;