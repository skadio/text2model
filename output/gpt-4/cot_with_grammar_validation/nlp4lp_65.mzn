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
array[1..N] of var 0..2: CentralIntervention;
array[1..N] of var 0..2: DistributedIntervention;

% Constraints
constraint forall(i in 1..N) (
  (CentralIntervention[i] = 1 -> IsolateCentral[i] <= CentralMaxHours) /\
  (CentralIntervention[i] = 2 -> ScanCentral[i] <= CentralMaxHours) /\
  (DistributedIntervention[i] = 1 -> IsolateDistributed[i] <= DistributedMaxHours) /\
  (DistributedIntervention[i] = 2 -> ScanDistributed[i] <= DistributedMaxHours)
);

constraint sum(i in 1..N) (
  CentralIntervention[i] * (if CentralIntervention[i] = 1 then IsolateCentral[i] else ScanCentral[i] endif)
) <= CentralMaxHours;

constraint sum(i in 1..N) (
  DistributedIntervention[i] * (if DistributedIntervention[i] = 1 then IsolateDistributed[i] else ScanDistributed[i] endif)
) <= DistributedMaxHours;

% Objective
var int: TotalCost = sum(i in 1..N) (
  CentralIntervention[i] * CentralCost + DistributedIntervention[i] * DistributedCost
);

solve minimize TotalCost;