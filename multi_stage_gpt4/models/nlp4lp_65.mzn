% Parameters
int: N; % Number of interventions
array[1..N] of int: IsolateCentral; % Processing time for isolating at the central system for each intervention
array[1..N] of int: ScanCentral; % Processing time for scanning at the central system for each intervention
array[1..N] of int: IsolateDistributed; % Processing time for isolating at the distributed system for each intervention
array[1..N] of int: ScanDistributed; % Processing time for scanning at the distributed system for each intervention
int: CentralCost; % Cost for central system intervention
int: DistributedCost; % Cost for distributed system intervention
int: CentralMaxHours; % Maximum hours of operation for the central system
int: DistributedMaxHours; % Maximum hours of operation for the distributed system

% Variables
% Decision variables for each intervention whether it is processed in the central system or not
array[1..N] of var 0..1: central_process;
% Decision variables for each intervention whether it is processed in the distributed system or not
array[1..N] of var 0..1: distributed_process;
% Decision variables for each intervention whether it is isolated or not
array[1..N] of var 0..1: isolate;
% Decision variables for each intervention whether it is scanned or not
array[1..N] of var 0..1: scan;

% Constraints

% Each intervention must be processed either in the central system or in the distributed system, but not both
constraint forall(i in 1..N) (
    central_process[i] + distributed_process[i] = 1
);

% Each intervention must be either isolated or scanned, but not both
constraint forall(i in 1..N) (
    isolate[i] + scan[i] = 1
);

% The total processing time for all interventions in the central system must not exceed the maximum hours of operation for the central system
constraint sum(i in 1..N) (
    central_process[i] * (IsolateCentral[i] * isolate[i] + ScanCentral[i] * scan[i])
) <= CentralMaxHours;

% The total processing time for all interventions in the distributed system must not exceed the maximum hours of operation for the distributed system
constraint sum(i in 1..N) (
    distributed_process[i] * (IsolateDistributed[i] * isolate[i] + ScanDistributed[i] * scan[i])
) <= DistributedMaxHours;

% The total cost for all interventions in the central system must not exceed the cost for central system intervention
constraint sum(i in 1..N) (
    central_process[i] * CentralCost
) <= CentralCost * N;

% The total cost for all interventions in the distributed system must not exceed the cost for distributed system intervention
constraint sum(i in 1..N) (
    distributed_process[i] * DistributedCost
) <= DistributedCost * N;

% Objective
% Minimize the total cost of interventions
solve minimize sum(i in 1..N) (
    central_process[i] * CentralCost + distributed_process[i] * DistributedCost
);