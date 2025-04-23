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
% For each intervention, 0 if it is processed centrally, 1 if it is processed distributedly
array[1..N] of var 0..1: interventionProcessing;
% For each intervention, 0 if it is isolated, 1 if it is scanned
array[1..N] of var 0..1: interventionType;
% Total cost of the interventions
var int: totalCost;

% Constraints

% Constraint: Total processing time for central system should not exceed CentralMaxHours
constraint sum(i in 1..N) (
    (interventionProcessing[i] = 0) * 
    ((interventionType[i] = 0) * IsolateCentral[i] + (interventionType[i] = 1) * ScanCentral[i])
) <= CentralMaxHours;

% Constraint: Total processing time for distributed system should not exceed DistributedMaxHours
constraint sum(i in 1..N) (
    (interventionProcessing[i] = 1) * 
    ((interventionType[i] = 0) * IsolateDistributed[i] + (interventionType[i] = 1) * ScanDistributed[i])
) <= DistributedMaxHours;

% Constraint: Total cost is the sum of the cost of all interventions
constraint totalCost = sum(i in 1..N) (
    (interventionProcessing[i] = 0) * CentralCost + 
    (interventionProcessing[i] = 1) * DistributedCost
);

% Objective
solve minimize totalCost;