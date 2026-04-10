% P-Median Problem (MiniZinc)

% Parameters
int: P;
int: num_customers;
int: num_warehouses;

set of int: Customers = 1..num_customers;
set of int: Warehouses = 1..num_warehouses;

array[Customers] of float: Demand;
array[Customers, Warehouses] of float: Distance;

% Decision Variables
array[Warehouses] of var bool: open;
array[Customers, Warehouses] of var bool: assign;

% Constraints
constraint P >= 0 /\ P <= num_warehouses;

% Open exactly P warehouses
constraint sum(w in Warehouses)(bool2int(open[w])) = P;

% Each customer assigned to exactly one warehouse
constraint forall(c in Customers)(
  sum(w in Warehouses)(bool2int(assign[c,w])) = 1
);

% Customers can only be assigned to open warehouses
constraint forall(c in Customers, w in Warehouses)(
  assign[c,w] -> open[w]
);

% Objective: minimize total demand-weighted distance
solve minimize
  sum(c in Customers, w in Warehouses)(
    Demand[c] * Distance[c,w] * bool2float(assign[c,w])
  );