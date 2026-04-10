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
array[1..N] of var 0..1: doIsolate;   % 1 = isolate, 0 = scan
array[1..N] of var 0..1: useCentral;  % 1 = central, 0 = distributed

var 0..sum(i in 1..N)(max(IsolateCentral[i], ScanCentral[i])): centralHoursUsed;
var 0..sum(i in 1..N)(max(IsolateDistributed[i], ScanDistributed[i])): distributedHoursUsed;

var int: totalCost;

% Constraints
constraint centralHoursUsed =
  sum(i in 1..N)(
    useCentral[i] * (doIsolate[i] * IsolateCentral[i] + (1 - doIsolate[i]) * ScanCentral[i])
  );

constraint distributedHoursUsed =
  sum(i in 1..N)(
    (1 - useCentral[i]) * (doIsolate[i] * IsolateDistributed[i] + (1 - doIsolate[i]) * ScanDistributed[i])
  );

constraint centralHoursUsed <= CentralMaxHours;
constraint distributedHoursUsed <= DistributedMaxHours;

constraint totalCost =
  CentralCost * sum(i in 1..N)(useCentral[i]) +
  DistributedCost * sum(i in 1..N)(1 - useCentral[i]);

% Objective
solve minimize totalCost;