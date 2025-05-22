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
% 0 = no intervention, 1 = isolate, 2 = scan
array[1..N] of var 0..2: InterventionCentral;
array[1..N] of var 0..2: InterventionDistributed;

% Constraints
constraint forall(i in 1..N) (
    (InterventionCentral[i] = 1 -> IsolateCentral[i] <= CentralMaxHours) /\
    (InterventionCentral[i] = 2 -> ScanCentral[i] <= CentralMaxHours) /\
    (InterventionDistributed[i] = 1 -> IsolateDistributed[i] <= DistributedMaxHours) /\
    (InterventionDistributed[i] = 2 -> ScanDistributed[i] <= DistributedMaxHours)
);

constraint forall(i in 1..N) (
    InterventionCentral[i] + InterventionDistributed[i] <= 2
);

% Objective
var int: TotalCost = sum(i in 1..N) (
    InterventionCentral[i] * CentralCost + InterventionDistributed[i] * DistributedCost
);

solve minimize TotalCost;