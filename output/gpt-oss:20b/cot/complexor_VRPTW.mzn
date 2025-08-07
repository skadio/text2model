% Parameters
int: CustomerCount;
int: VehicleCount;
array[1..CustomerCount] of int: CustomerDemand;
array[1..CustomerCount] of int: CustomerLBTW;
array[1..CustomerCount] of int: CustomerUBTW;
array[1..CustomerCount, 1..CustomerCount] of int: CustomerDistance;
array[1..CustomerCount] of int: CustomerServiceTime;
array[1..VehicleCount] of int: VehicleCapacity;

set of int: Customers = 1..CustomerCount;
set of int: Vehicles = 1..VehicleCount;
set of int: Nodes = 0..CustomerCount;

% Derived distance matrix including depot (node 0)
array[Nodes, Nodes] of int: Distance = 
  [ if i = 0 \/ j = 0 then 0 else CustomerDistance[i, j] endif
    | i in Nodes, j in Nodes ];

% Variables
array[Vehicles, Nodes, Nodes] of var bool: x;          % route arcs
array[Vehicles, Nodes] of var 0..VehicleCapacity[1] : load; % vehicle load at node
array[Nodes] of var int: arrival;                      % arrival time at node

% Constraints
constraint
  % Each customer is visited exactly once
  forall(i in Customers) (
    sum(v in Vehicles, j in Nodes) (x[v, i, j]) = 1
  ) /\
  forall(i in Customers) (
    sum(v in Vehicles, j in Nodes) (x[v, j, i]) = 1
  );

constraint
  % Each vehicle starts and ends at depot
  forall(v in Vehicles) (
    sum(i in Customers) (x[v, 0, i]) = 1 /\
    sum(i in Customers) (x[v, i, 0]) = 1
  );

constraint
  % Flow conservation for intermediate nodes
  forall(v in Vehicles, i in Customers) (
    sum(j in Nodes) (x[v, i, j]) = sum(j in Nodes) (x[v, j, i])
  );

constraint
  % Load constraints
  forall(v in Vehicles, i in Customers) (
    load[v, i] = sum(j in Nodes) (x[v, j, i] * CustomerDemand[i])
  ) /\
  forall(v in Vehicles, i in Customers) (
    load[v, i] <= VehicleCapacity[v]
  );

constraint
  % Arrival time bounds
  forall(i in Customers) (
    arrival[i] >= CustomerLBTW[i] /\
    arrival[i] <= CustomerUBTW[i]
  );

constraint
  % Time propagation
  forall(v in Vehicles, i in Customers, j in Customers) (
    x[v, i, j] -> arrival[j] >= arrival[i] + CustomerServiceTime[i] + Distance[i, j]
  );

% Objective
solve minimize
  sum(v in Vehicles, i in Nodes, j in Nodes) (x[v, i, j] * Distance[i, j]);