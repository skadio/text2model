include "globals.mzn";

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
array[1..N] of var 0..1: Isolate; % Decision variable for isolating intervention
array[1..N] of var 0..1: Scan; % Decision variable for scanning intervention
var int: CentralHours; % Total hours of operation for the central system
var int: DistributedHours; % Total hours of operation for the distributed system

% Constraints
constraint forall(i in 1..N) (
    Isolate[i] + Scan[i] = 1 % Each intervention must be either isolate or scan
);

constraint CentralHours = sum(i in 1..N) (
    Isolate[i]*IsolateCentral[i] + Scan[i]*ScanCentral[i]
) <= CentralMaxHours;

constraint DistributedHours = sum(i in 1..N) (
    Isolate[i]*IsolateDistributed[i] + Scan[i]*ScanDistributed[i]
) <= DistributedMaxHours;

% Objective
var int: TotalCost = CentralHours*CentralCost + DistributedHours*DistributedCost;
solve minimize TotalCost;

% Output
output ["Total cost: ", show(TotalCost), "\n",
        "Central hours: ", show(CentralHours), "\n",
        "Distributed hours: ", show(DistributedHours), "\n",
        "Isolate: ", show(Isolate), "\n",
        "Scan: ", show(Scan), "\n"];