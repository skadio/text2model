include "globals.mzn";

%----------------------------
% Parameters
%----------------------------
int: CustomerCount; % number of customers
int: VehicleCount;  % number of vehicles

set of int: CUSTOMERS = 1..CustomerCount;
set of int: VEHICLES  = 1..VehicleCount;

array[CUSTOMERS] of int: CustomerDemand;
array[CUSTOMERS] of int: CustomerLBTW;
array[CUSTOMERS] of int: CustomerUBTW;
array[CUSTOMERS, CUSTOMERS] of int: CustomerDistance;
array[CUSTOMERS] of int: CustomerServiceTime;

array[VEHICLES] of int: VehicleCapacity;

% Helpful derived bounds
int: maxTimeUB  = max(CustomerUBTW);
int: maxService = max(CustomerServiceTime);
int: maxDist    = max([CustomerDistance[i,j] | i in CUSTOMERS, j in CUSTOMERS]);

int: BigM = maxTimeUB + maxService + maxDist;

%----------------------------
% Variables
%----------------------------
array[VEHICLES, CUSTOMERS, CUSTOMERS] of var 0..1: travel;
array[VEHICLES, CUSTOMERS] of var 0..1: servedBy;
array[VEHICLES, CUSTOMERS] of var 0..maxTimeUB: startTime;
array[VEHICLES] of var 0..sum(CustomerDemand): load;

var 0..(VehicleCount * CustomerCount * maxDist): totalTravelCost;

%----------------------------
% Constraints
%----------------------------

% Disallow self-loops
constraint forall(v in VEHICLES, i in CUSTOMERS)(travel[v,i,i] = 0);

% Each customer served by exactly one vehicle
constraint forall(i in CUSTOMERS)(
  sum(v in VEHICLES)(servedBy[v,i]) = 1
);

% Link servedBy with routing decisions (degree constraints)
constraint forall(v in VEHICLES, i in CUSTOMERS)(
  sum(j in CUSTOMERS where j != i)(travel[v,i,j]) = servedBy[v,i]
);
constraint forall(v in VEHICLES, i in CUSTOMERS)(
  sum(j in CUSTOMERS where j != i)(travel[v,j,i]) = servedBy[v,i]
);

% Eliminate subtours within each vehicle route
constraint forall(v in VEHICLES)(
  circuit(array2d(CUSTOMERS, CUSTOMERS, [travel[v,i,j] | i in CUSTOMERS, j in CUSTOMERS]))
);

% Vehicle capacity
constraint forall(v in VEHICLES)(
  load[v] = sum(i in CUSTOMERS)(CustomerDemand[i] * servedBy[v,i])
);
constraint forall(v in VEHICLES)(
  load[v] <= VehicleCapacity[v]
);

% Time windows enforced only if served
constraint forall(v in VEHICLES, i in CUSTOMERS)(
  servedBy[v,i] = 1 ->
    (CustomerLBTW[i] <= startTime[v,i] /\ startTime[v,i] <= CustomerUBTW[i])
);

% Time propagation along arcs (only meaningful if arc used)
constraint forall(v in VEHICLES, i in CUSTOMERS, j in CUSTOMERS where i != j)(
  startTime[v,j] >= startTime[v,i] + CustomerServiceTime[i] + CustomerDistance[i,j]
                - BigM * (1 - travel[v,i,j])
);

% Total travel cost
constraint totalTravelCost =
  sum(v in VEHICLES, i in CUSTOMERS, j in CUSTOMERS where i != j)(
    CustomerDistance[i,j] * travel[v,i,j]
  );

%----------------------------
% Objective
%----------------------------
solve minimize totalTravelCost;