% Parameters
int: N;
array[1..N] of int: IsolateCentral;
array[1..N] of int: ScanCentral;
array[1..N] of int: IsolateDistributed;
array[1..N] of int: ScanDistributed;
int: CentralCost;
int: DistributedCost;
int: CentralMaxHours;
int: DistributedMaxHours;

% Variables
array[1..N] of var 0..1: Isolate;
array[1..N] of var 0..1: Scan;
array[1..N] of var 0..1: Central;
array[1..N] of var 0..1: Distributed;
var 0..CentralMaxHours: CentralHours;
var 0..DistributedMaxHours: DistributedHours;

% Constraints
constraint forall(i in 1..N) (
    Isolate[i] + Scan[i] = 1 /\ Central[i] + Distributed[i] = 1
);
constraint CentralHours = sum(i in 1..N) (
    Central[i]*(Isolate[i]*IsolateCentral[i] + Scan[i]*ScanCentral[i])
);
constraint DistributedHours = sum(i in 1..N) (
    Distributed[i]*(Isolate[i]*IsolateDistributed[i] + Scan[i]*ScanDistributed[i])
);
constraint CentralHours <= CentralMaxHours;
constraint DistributedHours <= DistributedMaxHours;

% Objective
var int: TotalCost = CentralHours*CentralCost + DistributedHours*DistributedCost;
solve minimize TotalCost;