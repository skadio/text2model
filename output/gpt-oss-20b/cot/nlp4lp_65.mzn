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
array[1..N] of var bool: isCentral;
array[1..N] of var bool: isIsolate;

% Constraints
constraint
  sum(i in 1..N) (
    isCentral[i] * (isIsolate[i] * IsolateCentral[i] + (1 - isIsolate[i]) * ScanCentral[i])
  ) <= CentralMaxHours;

constraint
  sum(i in 1..N) (
    (1 - isCentral[i]) * (isIsolate[i] * IsolateDistributed[i] + (1 - isIsolate[i]) * ScanDistributed[i])
  ) <= DistributedMaxHours;

% Objective
solve minimize
  sum(i in 1..N) (
    isCentral[i] * CentralCost + (1 - isCentral[i]) * DistributedCost
  );