% Parameters
int: CustomerCount;                         % number of customers
int: VehicleCount;                          % number of vehicles

set of int: CUSTOMERS = 1..CustomerCount;   % customer index set
set of int: VEHICLES  = 1..VehicleCount;    % vehicle index set

array[CUSTOMERS] of int: CustomerDemand;               % demand of each customer
array[CUSTOMERS] of int: CustomerLBTW;                 % lower bound of time window for each customer
array[CUSTOMERS] of int: CustomerUBTW;                 % upper bound of time window for each customer
array[CUSTOMERS, CUSTOMERS] of int: CustomerDistance;  % travel distance/cost between customers
array[CUSTOMERS] of int: CustomerServiceTime;          % service time at each customer
array[VEHICLES] of int: VehicleCapacity;               % capacity of each vehicle

% Helper bounds derived from input data (used to bound decision variables / Big-M)
int: MinTW = min(CustomerLBTW);
int: MaxTW = max(CustomerUBTW);
int: MaxService = max(CustomerServiceTime);
int: MaxDist = max([CustomerDistance[i,j] | i in CUSTOMERS, j in CUSTOMERS]);

% A conservative Big-M for time constraints
int: BigM = MaxTW + MaxService + MaxDist;

% Variables
array[VEHICLES, CUSTOMERS, CUSTOMERS] of var 0..1: x;
% x[v,i,j] = 1 if vehicle v travels directly from customer i to customer j (arc between customers)

array[VEHICLES, CUSTOMERS] of var 0..1: serve;
% serve[v,i] = 1 if vehicle v serves customer i

array[VEHICLES, CUSTOMERS] of var MinTW..(MaxTW + MaxService + MaxDist): startTime;
% startTime[v,i] = service start time of vehicle v at customer i


% Constraints

% Each customer must be served by exactly one vehicle
constraint
  forall(i in CUSTOMERS) (
    sum(v in VEHICLES)(serve[v,i]) = 1
  );

% Vehicle capacity constraints (sum of demands of served customers cannot exceed capacity)
constraint
  forall(v in VEHICLES) (
    sum(i in CUSTOMERS)(CustomerDemand[i] * serve[v,i]) <= VehicleCapacity[v]
  );

% Link serve decisions to routing arcs:
% If vehicle v serves customer i, it must have exactly one outgoing and one incoming arc at i.
constraint
  forall(v in VEHICLES, i in CUSTOMERS) (
    sum(j in CUSTOMERS where j != i)(x[v,i,j]) = serve[v,i]
  );

constraint
  forall(v in VEHICLES, i in CUSTOMERS) (
    sum(j in CUSTOMERS where j != i)(x[v,j,i]) = serve[v,i]
  );

% Eliminate self-loops explicitly
constraint
  forall(v in VEHICLES, i in CUSTOMERS) (
    x[v,i,i] = 0
  );

% Time window constraints:
% If a vehicle serves customer i, its start time must be within [LBTW, UBTW].
% If not served, these constraints are relaxed via Big-M style bounding.
constraint
  forall(v in VEHICLES, i in CUSTOMERS) (
    startTime[v,i] >= CustomerLBTW[i] * serve[v,i] + MinTW * (1 - serve[v,i])
  );

constraint
  forall(v in VEHICLES, i in CUSTOMERS) (
    startTime[v,i] <= CustomerUBTW[i] * serve[v,i] + BigM * (1 - serve[v,i])
  );

% Time propagation along used arcs:
% If x[v,i,j] = 1 then startTime[v,j] >= startTime[v,i] + serviceTime[i] + travel(i,j).
% Big-M deactivates the constraint when the arc is not used.
constraint
  forall(v in VEHICLES, i in CUSTOMERS, j in CUSTOMERS where i != j) (
    startTime[v,j] >=
      startTime[v,i] + CustomerServiceTime[i] + CustomerDistance[i,j]
      - BigM * (1 - x[v,i,j])
  );


% Objective
solve minimize
  sum(v in VEHICLES, i in CUSTOMERS, j in CUSTOMERS where i != j)(
    CustomerDistance[i,j] * x[v,i,j]
  );