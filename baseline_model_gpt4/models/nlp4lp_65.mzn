include "globals.mzn";

% Number of interventions
int: N;

% Processing time for isolating at the central system for each intervention
array[1..N] of int: IsolateCentral;

% Processing time for scanning at the central system for each intervention
array[1..N] of int: ScanCentral;

% Processing time for isolating at the distributed system for each intervention
array[1..N] of int: IsolateDistributed;

% Processing time for scanning at the distributed system for each intervention
array[1..N] of int: ScanDistributed;

% Cost for central system intervention
int: CentralCost;

% Cost for distributed system intervention
int: DistributedCost;

% Maximum hours of operation for the central system
int: CentralMaxHours;

% Maximum hours of operation for the distributed system
int: DistributedMaxHours;

% Decision variables
var 0..1: central[N];
var 0..1: distributed[N];

% Objective function
var int: total_cost;
constraint total_cost = sum(i in 1..N) ((central[i] * (IsolateCentral[i] + ScanCentral[i]) * CentralCost) + (distributed[i] * (IsolateDistributed[i] + ScanDistributed[i]) * DistributedCost));

% Constraints
constraint forall(i in 1..N) (central[i] + distributed[i] = 1);
constraint sum(i in 1..N) (central[i] * (IsolateCentral[i] + ScanCentral[i])) <= CentralMaxHours;
constraint sum(i in 1..N) (distributed[i] * (IsolateDistributed[i] + ScanDistributed[i])) <= DistributedMaxHours;

% Solve
solve minimize total_cost;

% Output
output ["Total cost: ", show(total_cost), "\n"] ++
["Central: ", show(central), "\n"] ++
["Distributed: ", show(distributed), "\n"];